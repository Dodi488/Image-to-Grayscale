include("img2gray.jl")
include("convert.jl")

using FileIO
using Images

img = load("test.png")
img = RGB.(img)
#img = Array(img)
#img = ROCArray(img)
println(size(img))

gray_tensor = img2gray!(img)
println(size(gray_tensor))

save("gray.png", Array(gray_tensor))
