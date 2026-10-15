using AMDGPU

function img2gray_kernel!(input::UInt8, output::UInt8, width::Int32, height::Int32)
	x::Int32 = blockIdx.x * blockDim.x + threadIdx.x
	y::Int32 = blockIdx.y * blockDim.y + threadIdx.y

	if x < width && y < height
		idx::Int32 = (y * width + x) * 3
		r::UInt8 = input[idx]
		g::UInt8 = input[idx + 1]
		b::UInt8 = input[idx + 2]

		gray::UInt8 = UInt8(0.2f * r + 0.7f * g + 0.07 * b)
		output[y * width + x] = gray
	end
end

function img2gray_AMDGPU!(input::ROCArray, output::ROCArray)
	width::Int32 = size(input, 2)
	height::Int32 = size(input, 1)

	block_size = (16, 16)
	#grid_size = ((width + block_size.x - 1) / block_size.x, (height + block_size.y - 1) / block_size.y)
	grid_size = ((width + block_size[1] - 1) / block_size[1], (height + block_size[2] - 1) / block_size[2])

	img2gray_kernel!(UInt8(input), UInt8(output), width, height)
end
