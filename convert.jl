using AMDGPU

include("img2gray.jl")

function img2gray!(input)
	#height, width, channles = size(input)
	#Float64(height), Float64(width) = size(input)
	input = ROCArray(input)
	height, width = size(input)
	#height = Float64(height)
	#width = Float64(width)
	#@assert channles == 3

	#output = ROCArray((height, width), device)
	#output = similar(input, (height, width))
	#output = ROCArray((height, width))
	output = ROCArray{Float64}(undef, height, width)
	println(typeof(input))
	println(typeof(output))
	#output = ROCArray((height, width))
	#@roc img2gray_AMDGPU!(input, output)
	img2gray_AMDGPU!(input, output)

	return output
end
