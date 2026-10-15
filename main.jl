include("img2gray.jl")
include("convert.jl")

using FileIO
using Images

img = load("test.png")
img = RGB.(img)
img = Array(img)
img_tensor = ROCArray(img)
println(size(img_tensor))

gray_tensor = img2gray!(img_tensor)
print(size(gray_tensor))

save("gray.png", Gray.(gray_tensor))
