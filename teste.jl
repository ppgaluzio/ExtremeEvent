
using LSODA
using FFTW


function fex!(t::Float64, x::Array{Float64, 1}, ydot::Array{Float64, 1}, data::Nothing)
    ydot[1]=1.0E4 * x[2] * x[3] - .04E0 * x[1]
	ydot[3]=3.0E7 * x[2] * x[2]
	ydot[2]=-ydot[1] - ydot[3]
end

"""
Calculates the energy associated with the wave ψ

ψ is the fourier transform of ϕ
"""
function energy(ψ::Array{Float64, 1})
    ϕ = ifft(ψ)
    ϕ² = abs(ϕ)^2
    ϕ⁴ = abs(ϕ)^4

end


y₀ = [1., 0.0, 0.0]
tspan = collect(0:0.01:100)
res =  lsoda(fex!, y₀, tspan)
