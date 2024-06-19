#define CL_TARGET_OPENCL_VERSION 120
#include <stdio.h>
#include <stdlib.h>
#include <vector>
#include <omp.h>
#include <CL/cl.h>
#include <string>
#include <map>
#define LOC_SIZE_r2 16
#define LOC_SIZE_r3 30
#define THREAD_WORK_X 2
#define THREAD_WORK_Y 3

struct DeviceInfo {
	std::string deviceName;
	cl_device_id deviceId;
	cl_device_type deviceType;
	std::string platformName;
};

struct PlatformDevices {
	cl_platform_id platformId;
	std::string platformName;
	std::vector<DeviceInfo> devices;
};

bool ReadMatrix(cl_int size_X, cl_int size_Y, cl_float* matrix, FILE* file)
{
	for (int i = 0; i < size_X * size_Y; i++) {
		if (fscanf(file, "%f", &matrix[i]) != 1) {
			printf("Error in reading file");
			return 1;
		}
	}
	return 0;
}

std::vector<PlatformDevices> getAllPlatformsAndDevices() {
	cl_uint num_platforms;
	clGetPlatformIDs(0, NULL, &num_platforms);
	std::vector<cl_platform_id> platform_ids(num_platforms);
	clGetPlatformIDs(num_platforms, platform_ids.data(), NULL);

	std::vector<PlatformDevices> allPlatforms;

	for (size_t i = 0; i < platform_ids.size(); ++i) {
		PlatformDevices pd;
		pd.platformId = platform_ids[i];

		size_t size;
		clGetPlatformInfo(platform_ids[i], CL_PLATFORM_NAME, 0, NULL, &size);
		std::vector<char> pl_name(size);
		clGetPlatformInfo(platform_ids[i], CL_PLATFORM_NAME, size, pl_name.data(), NULL);
		pd.platformName = std::string(pl_name.begin(), pl_name.end());

		cl_uint num_devices;
		clGetDeviceIDs(platform_ids[i], CL_DEVICE_TYPE_ALL, 0, NULL, &num_devices);
		std::vector<cl_device_id> device_ids(num_devices);
		clGetDeviceIDs(platform_ids[i], CL_DEVICE_TYPE_ALL, num_devices, device_ids.data(), NULL);

		for (size_t j = 0; j < device_ids.size(); ++j) {
			DeviceInfo di;
			di.deviceId = device_ids[j];

			clGetDeviceInfo(device_ids[j], CL_DEVICE_NAME, 0, NULL, &size);
			std::vector<char> dev_name(size);
			clGetDeviceInfo(device_ids[j], CL_DEVICE_NAME, size, dev_name.data(), NULL);
			di.deviceName = std::string(dev_name.begin(), dev_name.end());

			cl_device_type type;
			clGetDeviceInfo(device_ids[j], CL_DEVICE_TYPE, sizeof(type), &type, NULL);
			di.deviceType = type;
			std::string pl_name_str(pl_name.begin(), pl_name.end());
			di.platformName = pl_name_str;
			pd.devices.push_back(di);
		}

		allPlatforms.push_back(pd);
	}
	return allPlatforms;
}

std::map<std::string, std::vector<cl_device_id>> SelectDevice(const std::vector<PlatformDevices>& PlatformsAndDevices) {
	std::map<std::string, std::vector<cl_device_id>> listdevices;
	for (const PlatformDevices& platform : PlatformsAndDevices) {
		for (const DeviceInfo& device : platform.devices) {
			if (device.deviceType == CL_DEVICE_TYPE_GPU) {
				cl_bool unifiedMemory;
				clGetDeviceInfo(device.deviceId, CL_DEVICE_HOST_UNIFIED_MEMORY, sizeof(unifiedMemory), &unifiedMemory, NULL);
				if (unifiedMemory) {
					listdevices["igpu"].push_back(device.deviceId);
				}
				else {
					listdevices["dgpu"].push_back(device.deviceId);
				}
			}
			else if (device.deviceType == CL_DEVICE_TYPE_CPU) {
				listdevices["cpu"].push_back(device.deviceId);
			}
			else {
				listdevices["all"].push_back(device.deviceId);
			}
		}
	}
	return listdevices;
}

void MatMul_omp(float* A, float* B, float* C, cl_uint M, cl_uint N, cl_uint K) {
	volatile double tstart = omp_get_wtime();
#pragma omp parallel for num_threads(12)
	for (int i = 0; i < M; ++i)
	{
		for (int j = 0; j < N; ++j)
		{
			C[i * N + j] = 0;

			for (int k = 0; k < K; ++k)
			{
				C[i * N + j] += A[i * K + k] * B[k * N + j];
			}
		}
	}
	volatile double tend = omp_get_wtime();
	printf("Time: %g\n", (double)((tend - tstart) * 1000));
}

void writeMatrixToFile(int N, int M, cl_float* matrix, const char* filename) {
	FILE* file = fopen(filename, "w");
	if (file == NULL) {
		fprintf(stderr, "Error during opening file\n");
		return;
	}
	fprintf(file, "%d %d\n", N, M);
	for (int i = 0; i < M; i++) {
		for (int j = 0; j < N; j++) {
			fprintf(file, "%.6f ", matrix[i * N + j]);
		}
		fprintf(file, "\n");
	}
	fclose(file);
}

void Transpose(float* Inp_Matrix, float* Out_Matrix, cl_uint Inp_size_X, cl_uint Inp_size_Y) {
	for (unsigned int j = 0; j < Inp_size_Y; j++) {
		for (unsigned int i = 0; i < Inp_size_X; i++) {
			Out_Matrix[i * Inp_size_Y + j] = Inp_Matrix[j * Inp_size_X + i];
		}
	}
}

void releaseOpenCLResources(cl_kernel* kernel, cl_mem* a, cl_mem* b, cl_mem* c, cl_program* program,
	cl_command_queue* queue, cl_context* context)
{
	if (kernel != NULL && *kernel != NULL) {
		clReleaseKernel(*kernel);
		*kernel = NULL;
	}
	if (a != NULL && *a != NULL) {
		clReleaseMemObject(*a);
		*a = NULL;
	}
	if (b != NULL && *b != NULL) {
		clReleaseMemObject(*b);
		*b = NULL;
	}
	if (c != NULL && *c != NULL) {
		clReleaseMemObject(*c);
		*c = NULL;
	}
	if (program != NULL && *program != NULL) {
		clReleaseProgram(*program);
		*program = NULL;
	}
	if (queue != NULL && *queue != NULL) {
		clReleaseCommandQueue(*queue);
		*queue = NULL;
	}
	if (context != NULL && *context != NULL) {
		clReleaseContext(*context);
		*context = NULL;
	}
}

void freeMatrixMemory(float* a, float* b, float* c) {
	if (a != NULL) {
		free(a);
	}
	if (b != NULL) {
		free(b);
	}
	if (c != NULL) {
		free(c);
	}
}


int main(int argc, char* argv[]) {
	std::map<std::string, std::string> args;
	for (int i = 1; i < argc; i++) {
		std::string arg = argv[i];
		if (arg == "--input") {
			if (i + 1 < argc) {
				args["input"] = argv[++i];
			}
			else {
				printf("Wrong input type. Check --help");
				return 1;
			}
		}
		else if (arg == "--output") {
			if (i + 1 < argc) {
				args["output"] = argv[++i];
			}
			else {
				printf("Wrong input type. Check --help");
				return 1;
			}
		}
		else if (arg == "--realization") {
			if (i + 1 < argc) {
				std::string nextArg = argv[i + 1];
				if (nextArg == "0" || nextArg == "1" || nextArg == "2" || nextArg == "3") {
					args["realization"] = nextArg;
					i++;
				}
				else {
					printf("Wrong input type. Check --help");
					return 1;
				}
			}
		}
		else if (arg == "--device-type") {
			if (i + 1 < argc) {
				std::string nextArg = argv[i + 1];
				if (nextArg == "dgpu" || nextArg == "igpu" || nextArg == "gpu" || nextArg == "cpu" || nextArg == "all") {
					args["device-type"] = nextArg;
					i++;
				}
				else {
					printf("Wrong input type. Check --help");
					return 1;
				}
			}
		}
		else if (arg == "--device-index") {
			if (i + 1 < argc) {
				args["device-index"] = argv[i + 1];
				i++;
			}
			else {
				printf("Wrong input type. Check --help");
				return 1;
			}
		}
		else if (arg == "--help") {
			printf("lab0.exe < --input file_name > \\ \n< --output file_name > \\ \n --realizarion {0, 1, 2, 3} \\ \n[ --device-type { dgpu | igpu | gpu | cpu | all } ]\n[--device-index index ]");
			return 0;
		}
		else {
			printf("Unknown option %s", arg.c_str());
			return 1;
		}
	}
	const char* filename = args["input"].c_str();
	FILE* file = fopen(filename, "r");
	if (file == NULL) {
		fprintf(stderr, "Cannot open the file: %s\n", filename);
		return 1;
	}
	cl_uint M, K, N;
	if (fscanf(file, "%d %d %d", &N, &K, &M) != 3) {
		fprintf(stderr, "Failed to read matrix dimensions.\n");
		fclose(file);
		return 1;
	}
	cl_float* a_val = (cl_float*)malloc(M * K * sizeof(cl_float));
	cl_float* b_val = (cl_float*)malloc(K * N * sizeof(cl_float));
	if (a_val == NULL || b_val == NULL) {
		printf("Memory allocation failed\n");
		fclose(file);
		freeMatrixMemory(a_val, b_val, NULL);
		return 1;
	}
	if (ReadMatrix(M, K, a_val, file)) {
		fclose(file);
		freeMatrixMemory(a_val, b_val, NULL);
		printf("Failed to read data for matrix A\n");
		return 1;
	}
	if (ReadMatrix(K, N, b_val, file)) {
		fclose(file);
		freeMatrixMemory(a_val, b_val, NULL);
		printf("Failed to read data for matrix B\n");
		return 1;
	}
	fclose(file);

	const std::vector<PlatformDevices> PlatformsAndDevices = getAllPlatformsAndDevices();
	cl_int index;
	std::map<std::string, std::vector<cl_device_id>> listdevices = SelectDevice(PlatformsAndDevices);
	cl_device_id my_device = NULL;
	std::string my_device_name, my_platform_name;

	if (args.count("device-index") > 0) {
		index = std::stoi(args["device-index"]);
	}
	else {
		index = 0;
	}

	if (args.count("device-type") > 0) {
		std::string s = args["device-type"];
		if (s == "cpu") {
			if (index > listdevices["cpu"].size()) {
				index = 0;
			}
			if (listdevices["cpu"].size() == 0) {
				freeMatrixMemory(a_val, b_val, NULL);
				printf("Device to your requirements doesnt exist\n");
				return 1;
			}
			my_device = listdevices["cpu"].at(index);
		}
		else if (s == "all") {
			listdevices["dgpu"].insert(listdevices["dgpu"].end(), listdevices["igpu"].begin(), listdevices["igpu"].end());
			listdevices["dgpu"].insert(listdevices["dgpu"].end(), listdevices["cpu"].begin(), listdevices["cpu"].end());
			listdevices["dgpu"].insert(listdevices["dgpu"].end(), listdevices["all"].begin(), listdevices["all"].end());
			if (index > listdevices["dgpu"].size()) {
				index = 0;
			}
			if (listdevices["dgpu"].size() == 0) {
				my_device = NULL;
				freeMatrixMemory(a_val, b_val, NULL);
				printf("Device to your requirements doesnt exist\n");
				return 1;
			}
			my_device = listdevices["dgpu"].at(index);
		}
		else if (s == "gpu") {
			listdevices["dgpu"].insert(listdevices["dgpu"].end(), listdevices["igpu"].begin(), listdevices["igpu"].end());
			if (index > listdevices["dgpu"].size()) {
				index = 0;
			}
			if (listdevices["dgpu"].size() == 0) {
				my_device = NULL;
				freeMatrixMemory(a_val, b_val, NULL);
				printf("Device to your requirements doesnt exist\n");
				return 1;
			}
			my_device = listdevices["dgpu"].at(index);
		}
		else if (s == "igpu") {
			if (index > listdevices["igpu"].size()) {
				index = 0;
			}
			if (listdevices["igpu"].size() == 0) {
				my_device = NULL;
				freeMatrixMemory(a_val, b_val, NULL);
				printf("Device to your requirements doesnt exist\n");
				return 1;
			}
			my_device = listdevices["igpu"].at(index);
		}
		else if (s == "dgpu") {
			if (index > listdevices["dgpu"].size()) {
				index = 0;
			}
			if (listdevices["dgpu"].size() == 0) {
				my_device = NULL;
				freeMatrixMemory(a_val, b_val, NULL);
				printf("Device to your requirements doesnt exist\n");
				return 1;
			}
			my_device = listdevices["dgpu"].at(index);
		}
	}
	else {
		listdevices["dgpu"].insert(listdevices["dgpu"].end(), listdevices["igpu"].begin(), listdevices["igpu"].end());
		listdevices["dgpu"].insert(listdevices["dgpu"].end(), listdevices["cpu"].begin(), listdevices["cpu"].end());
		listdevices["dgpu"].insert(listdevices["dgpu"].end(), listdevices["all"].begin(), listdevices["all"].end());
		if (index > listdevices["dgpu"].size()) {
			index = 0;
		}
		my_device = listdevices["dgpu"].at(index);
	}
	bool flag = false;
	for (const PlatformDevices& platform : PlatformsAndDevices) {
		for (const DeviceInfo& device : platform.devices) {
			if (device.deviceId == my_device) {
				my_device_name = device.deviceName;
				my_platform_name = device.platformName;
				flag = true;
				break;
			}
		}
		if (flag)
			break;
	}
	cl_float* c_val = (cl_float*)malloc(sizeof(cl_float) * M * N);
	if (c_val == NULL)
	{
		printf("Error at memory allocation\n");
		freeMatrixMemory(a_val, b_val, NULL);
		return 1;
	}
	char realization = std::stoi(args["realization"]);
	if (realization == 0) {
		MatMul_omp(a_val, b_val, c_val, M, N, K);
		writeMatrixToFile(N, M, c_val, args["output"].c_str());
	}
	else
	{
		std::string kernels_name[3] = { "globalmem_r1", "localmem_r2", "localmem_vector_r3" };
		cl_int err;
		cl_context context = clCreateContext(NULL, 1, &my_device, NULL, NULL, &err);
		if (context == NULL || err != CL_SUCCESS) {
			printf("Error creating OpenCL context: %d\n", err);
			freeMatrixMemory(a_val, b_val, c_val);
			return 1;
		}
		cl_command_queue queue = clCreateCommandQueue(context, my_device, CL_QUEUE_PROFILING_ENABLE, &err);
		if (queue == NULL || err != CL_SUCCESS) {
			printf("Error creating OpenCL context: %d\n", err);
			releaseOpenCLResources(NULL, NULL, NULL, NULL, NULL, NULL, &context);
			freeMatrixMemory(a_val, b_val, c_val);
			return 1;
		}
		FILE* ptrFile = NULL;
		ptrFile = fopen("kernels.cl", "rb");
		if (!ptrFile)
		{
			printf("File doesn't read\n");
			releaseOpenCLResources(NULL, NULL, NULL, NULL, NULL, &queue, &context);
			freeMatrixMemory(a_val, b_val, c_val);
			return 1;
		}
		fseek(ptrFile, 0, SEEK_END);
		size_t size = ftell(ptrFile);
		rewind(ptrFile);
		char* data = (char*)malloc(sizeof(char) * (size + 1));
		if (data == NULL)
		{
			printf("Error at memory allocation\n");
			fclose(ptrFile);
			releaseOpenCLResources(NULL, NULL, NULL, NULL, NULL, &queue, &context);
			freeMatrixMemory(a_val, b_val, c_val);
			return 1;
		}
		size_t result = fread(data, 1, size, ptrFile);
		if (result != size)
		{
			printf("File read incorrect\n");
			fclose(ptrFile);
			releaseOpenCLResources(NULL, NULL, NULL, NULL, NULL, &queue, &context);
			freeMatrixMemory(a_val, b_val, c_val);
			free(data);
			return 1;
		}
		data[size] = 0;
		fclose(ptrFile);
		cl_program prog = clCreateProgramWithSource(context, 1, (const char**)&data, &size, NULL);
		if (prog == NULL) {
			printf("Error: clCreateProgramWithSource returns NULL\n");
			releaseOpenCLResources(NULL, NULL, NULL, NULL, NULL, &queue, &context);
			freeMatrixMemory(a_val, b_val, c_val);
			free(data);
			return 1;
		}
		free(data);
		cl_int build_result = clBuildProgram(prog, 1, &my_device, "", NULL, NULL);
		if (build_result) {
			size_t size_build_log;
			clGetProgramBuildInfo(prog, my_device, CL_PROGRAM_BUILD_LOG, 0, NULL, &size_build_log);
			std::vector <char> build_log_name(size_build_log);
			clGetProgramBuildInfo(prog, my_device, CL_PROGRAM_BUILD_LOG, size_build_log, build_log_name.data(), NULL);
			printf("%s\n", build_log_name.data());
			releaseOpenCLResources(NULL, NULL, NULL, NULL, &prog, &queue, &context);
			freeMatrixMemory(a_val, b_val, c_val);
			return 1;
		}
		cl_event write_event_1 = NULL, kernel_event = NULL, read_event = NULL, write_event_2 = NULL;
		cl_kernel kernel = NULL;
		cl_mem a = NULL;
		cl_mem b = NULL;
		cl_mem c = NULL;
		if (realization == 1) {
			cl_mem a = clCreateBuffer(context, CL_MEM_READ_ONLY, sizeof(cl_float) * M * K, NULL, NULL);
			cl_mem b = clCreateBuffer(context, CL_MEM_READ_ONLY, sizeof(cl_float) * K * N, NULL, NULL);
			cl_mem c = clCreateBuffer(context, CL_MEM_WRITE_ONLY, sizeof(cl_float) * M * N, NULL, NULL);
			if (a == NULL || b == NULL || c == NULL) {
				printf("Failed to create buffers\n");
				releaseOpenCLResources(NULL, &a, &b, &c, &prog, &queue, &context);
				freeMatrixMemory(a_val, b_val, c_val);
				return 1;
			}
			clEnqueueWriteBuffer(queue, a, CL_FALSE, 0, sizeof(cl_float) * M * K, a_val, 0, NULL, &write_event_1);
			clEnqueueWriteBuffer(queue, b, CL_FALSE, 0, sizeof(cl_float) * K * N, b_val, 0, NULL, &write_event_2);
			cl_kernel kernel = clCreateKernel(prog, kernels_name[0].c_str(), NULL);
			if (kernel == NULL) {
				printf("Error: kernel %s doesnt create\n", kernels_name[0].c_str());
				releaseOpenCLResources(NULL, &a, &b, &c, &prog, &queue, &context);
				freeMatrixMemory(a_val, b_val, c_val);
				return 1;
			}
			clSetKernelArg(kernel, 0, sizeof(cl_mem), &a);
			clSetKernelArg(kernel, 1, sizeof(cl_mem), &b);
			clSetKernelArg(kernel, 2, sizeof(cl_mem), &c);
			clSetKernelArg(kernel, 3, sizeof(cl_uint), &M);
			clSetKernelArg(kernel, 4, sizeof(cl_uint), &N);
			clSetKernelArg(kernel, 5, sizeof(cl_uint), &K);
			size_t global_work_size[2] = { N, M };
			clEnqueueNDRangeKernel(queue, kernel, 2, NULL, &global_work_size[0], NULL, 0, NULL, &kernel_event);
			clEnqueueReadBuffer(queue, c, CL_TRUE, 0, sizeof(cl_float) * M * N, c_val, 0, NULL, &read_event);
		}

		else if (realization == 2 || realization == 3) {
			cl_uint add_K = K, add_N = N, add_M = M;
			if (realization == 2) {
				add_K = LOC_SIZE_r2 * (K / LOC_SIZE_r2 + 1), add_M = LOC_SIZE_r2 * (M / LOC_SIZE_r2 + 1), add_N = LOC_SIZE_r2 * (N / LOC_SIZE_r2 + 1);
			}
			else if (realization == 3) {
				add_K = LOC_SIZE_r3 * (K / LOC_SIZE_r3 + 1), add_M = LOC_SIZE_r3 * (M / LOC_SIZE_r3 + 1), add_N = LOC_SIZE_r3 * (N / LOC_SIZE_r3 + 1);
			}
			cl_float* a_val_exp = (cl_float*)malloc(add_M * add_K * sizeof(cl_float));
			cl_float* b_val_exp = (cl_float*)malloc(add_K * add_N * sizeof(cl_float));
			cl_float* c_val_exp = (cl_float*)malloc(sizeof(cl_float) * add_M * add_N);
			if (a_val_exp == NULL || b_val_exp == NULL || c_val_exp == NULL) {
				printf("Memory allocation error\n");
				releaseOpenCLResources(NULL, NULL, NULL, NULL, &prog, &queue, &context);
				freeMatrixMemory(a_val, b_val, c_val);
				freeMatrixMemory(a_val_exp, b_val_exp, c_val_exp);
				return 1;
			}
			for (int i = 0; i < add_M; i++) {
				for (int j = 0; j < add_K; j++) {
					a_val_exp[i * add_K + j] = 0;
				}
			}
			for (int i = 0; i < M; i++) {
				for (int j = 0; j < K; j++) {
					a_val_exp[i * add_K + j] = a_val[i * K + j];
				}
			}
			for (int i = 0; i < add_K; i++) {
				for (int j = 0; j < add_N; j++) {
					b_val_exp[i * add_N + j] = 0;
				}
			}
			for (int i = 0; i < K; i++) {
				for (int j = 0; j < N; j++) {
					b_val_exp[i * add_N + j] = b_val[i * N + j];
				}
			}
			cl_float* a_t_val_exp = (cl_float*)malloc(add_M * add_K * sizeof(cl_float));
			if (a_t_val_exp == NULL) {
				printf("Memory allocation error\n");
				releaseOpenCLResources(NULL, NULL, NULL, NULL, &prog, &queue, &context);
				freeMatrixMemory(a_val, b_val, c_val);
				freeMatrixMemory(a_val_exp, b_val_exp, c_val_exp);
				return 1;
			}
			Transpose(a_val_exp, a_t_val_exp, add_K, add_M);

			cl_mem a = clCreateBuffer(context, CL_MEM_READ_ONLY, sizeof(cl_float) * add_M * add_K, NULL, NULL);
			cl_mem b = clCreateBuffer(context, CL_MEM_READ_ONLY, sizeof(cl_float) * add_K * add_N, NULL, NULL);
			cl_mem c = clCreateBuffer(context, CL_MEM_WRITE_ONLY, sizeof(cl_float) * add_M * add_N, NULL, NULL);
			if (a == NULL || b == NULL || c == NULL) {
				printf("Failed to create buffers\n");
				releaseOpenCLResources(NULL, &a, &b, &c, &prog, &queue, &context);
				freeMatrixMemory(a_val, b_val, c_val);
				freeMatrixMemory(a_val_exp, b_val_exp, c_val_exp);
				free(a_t_val_exp);
				return 1;
			}
			clEnqueueWriteBuffer(queue, a, CL_FALSE, 0, sizeof(cl_float) * add_M * add_K, a_t_val_exp, 0, NULL, &write_event_1);
			clEnqueueWriteBuffer(queue, b, CL_FALSE, 0, sizeof(cl_float) * add_K * add_N, b_val_exp, 0, NULL, &write_event_2);
			cl_kernel kernel = clCreateKernel(prog, kernels_name[realization - 1].c_str(), NULL);
			if (kernel == NULL) {
				printf("Error: kernel %s doesnt create\n", kernels_name[realization - 1].c_str());
				releaseOpenCLResources(NULL, &a, &b, &c, &prog, &queue, &context);
				freeMatrixMemory(a_val, b_val, c_val);
				freeMatrixMemory(a_val_exp, b_val_exp, c_val_exp);
				free(a_t_val_exp);
				return 1;
			}
			clSetKernelArg(kernel, 0, sizeof(cl_mem), &a);
			clSetKernelArg(kernel, 1, sizeof(cl_mem), &b);
			clSetKernelArg(kernel, 2, sizeof(cl_mem), &c);
			clSetKernelArg(kernel, 3, sizeof(cl_uint), &add_M);
			clSetKernelArg(kernel, 4, sizeof(cl_uint), &add_N);
			clSetKernelArg(kernel, 5, sizeof(cl_uint), &add_K);
			size_t global_work_size[2], local_work_size[2];
			if (realization == 2) {
				global_work_size[0] = add_N;
				global_work_size[1] = add_M;
				local_work_size[0] = LOC_SIZE_r2;
				local_work_size[1] = LOC_SIZE_r2;
			}
			if (realization == 3) {
				global_work_size[0] = add_N / THREAD_WORK_X;
				global_work_size[1] = add_M / THREAD_WORK_Y;
				local_work_size[0] = LOC_SIZE_r3 / THREAD_WORK_X;
				local_work_size[1] = LOC_SIZE_r3 / THREAD_WORK_Y;
			}
			clEnqueueNDRangeKernel(queue, kernel, 2, NULL, global_work_size, local_work_size, 0, NULL, &kernel_event);
			clEnqueueReadBuffer(queue, c, CL_TRUE, 0, sizeof(cl_float) * add_M * add_N, c_val_exp, 0, NULL, &read_event);
			for (int i = 0; i < M; i++) {
				for (int j = 0; j < N; j++) {
					c_val[i * N + j] = c_val_exp[i * add_N + j];
				}
			}
			free(a_t_val_exp);
			freeMatrixMemory(a_val_exp, b_val_exp, c_val_exp);
		}
		cl_ulong write_start_1, write_end_1, write_start_2, write_end_2, kernel_start, kernel_end, read_start, read_end;
		clGetEventProfilingInfo(write_event_1, CL_PROFILING_COMMAND_START, sizeof(cl_ulong), &write_start_1, NULL);
		clGetEventProfilingInfo(write_event_1, CL_PROFILING_COMMAND_END, sizeof(cl_ulong), &write_end_1, NULL);
		clGetEventProfilingInfo(write_event_2, CL_PROFILING_COMMAND_START, sizeof(cl_ulong), &write_start_2, NULL);
		clGetEventProfilingInfo(write_event_2, CL_PROFILING_COMMAND_END, sizeof(cl_ulong), &write_end_2, NULL);
		clGetEventProfilingInfo(kernel_event, CL_PROFILING_COMMAND_START, sizeof(cl_ulong), &kernel_start, NULL);
		clGetEventProfilingInfo(kernel_event, CL_PROFILING_COMMAND_END, sizeof(cl_ulong), &kernel_end, NULL);
		clGetEventProfilingInfo(read_event, CL_PROFILING_COMMAND_START, sizeof(cl_ulong), &read_start, NULL);
		clGetEventProfilingInfo(read_event, CL_PROFILING_COMMAND_END, sizeof(cl_ulong), &read_end, NULL);
		double kernel_time = (double)(kernel_end - kernel_start);
		double total_time = (double)((write_end_1 + write_end_2 - write_start_1 - write_start_2) + (kernel_end - kernel_start) + (read_end - read_start));
		printf("Device: %s\tPlatform: %s Time: %g\t%g\n", my_device_name.c_str(), my_platform_name.c_str(), kernel_time / 1e6, total_time / 1e6);
		if (realization == 2) {
			printf("LOCAL_WORK_SIZE [%i, %i]\nWI_WORK %i\n", LOC_SIZE_r2, LOC_SIZE_r2, 1);
		}
		if (realization == 3) {
			printf("LOCAL_WORK_SIZE [%i, %i]\nWI_WORK %i\n", LOC_SIZE_r3 / THREAD_WORK_X, LOC_SIZE_r3 / THREAD_WORK_Y, THREAD_WORK_X * THREAD_WORK_Y);
		}
		releaseOpenCLResources(&kernel, &a, &b, &c, &prog, &queue, &context);
	}
	writeMatrixToFile(N, M, c_val, args["output"].c_str());
	freeMatrixMemory(a_val, b_val, c_val);
}
