using AMDGPU

function img2gray!(input::ROCArray)
	#height, width, channles = size(input)
	height, width = size(input)
	#@assert channles == 3

	#output = ROCArray((height, width), device)
	output = similar(input, (height, width))
	@roc img2gray_kernel!(input)

	return output
end
