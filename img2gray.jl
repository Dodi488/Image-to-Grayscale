using AMDGPU
using Images

#function img2gray_kernel!(input::UInt8, output::UInt8, width::Float64, height::Float64)
function img2gray_kernel!(input, output, width, height)
#function img2gray_kernel!(input::AMDGPU.Device.ROCDeviceMatrix{RGB{N0f8}, 1}, output::AMDGPU.Device.ROCDeviceMatrix{RGB{N0f8}, 1}, width::Int64, height::Int64)
	#x::Float64 = blockIdx.x * blockDim.x + threadIdx.x
	#y::Float64 = blockIdx.y * blockDim.y + threadIdx.y
	x = (workgroupIdx().x - 1) * workgroupDim().x + workitemIdx().x
	y = (workgroupIdx().y - 1)* workgroupDim().y + workitemIdx().y

	if x <= width && y <= height
		@inbounds begin
			#idx::Float64 = (y * width + x) * 3
			#r::UInt8 = input[idx]
			#g::UInt8 = input[idx + 1]
			#b::UInt8 = input[idx + 2]
			#idx = (y * width + x) * 3
			#r = input[idx]
			#r = r(0x80)
			#g = input[idx + 1]
			#g = g(0x80)
			#b = input[idx + 2]
			#b = b(0x80)
			idx = input[y, x]
			r = idx.r
			g = idx.g
			b = idx.b

			#gray::UInt8 = UInt8(0.2f * r + 0.7f * g + 0.07 * b)
			#output[y * width + x] = gray
			#clamp!
			output[y, x] = (0.21f0 * r + 0.72f0 * g + 0.07f0 * b)
		end
	end
	return nothing
end

#function img2gray_AMDGPU!(input::ROCArray{RGB{N0f8}, 2, AMDGPU.Runtime.Mem.HIPBuffer}, output::ROCArray{RGB{N0f8}, 2, AMDGPU.Runtime.Mem.HIPBuffer})
function img2gray_AMDGPU!(input, output)
	#width::Float64 = size(input, 2)
	#height::Float64 = size(input, 1)
	width = size(input, 2)
	height = size(input, 1)

	block_size = (16, 16)
	#grid_size = ((width + block_size.x - 1) / block_size.x, (height + block_size.y - 1) / block_size.y)
	#grid_size = ((width + block_size[1] - 1) / block_size[1], (height + block_size[2] - 1) / block_size[2])
	grid_size = ((width + block_size[1] - 1) ÷ block_size[1], (height + block_size[2] - 1) ÷ block_size[2])

	#img2gray_kernel!(UInt8(input), UInt8(output), width, height)
	@roc groupsize=block_size gridsize=grid_size img2gray_kernel!(input, output, width, height)
end
