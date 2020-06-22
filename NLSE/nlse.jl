#!/usr/bin/julia

###############################################################################
#                                     NLSE                                    #
###############################################################################

using DifferentialEquations
using FFTW
using Random
using Statistics
using Plots


function fex!(du, u, p, t)
    ϵ, g, ω², vb, γ, k = p

    N = length(u) ÷ 2
    ψ = u[1:N] + im * u[(N+1):end]

    # alias
    ψ[N÷3:2*N÷3] = zeros(N÷3+1)

    # nonlinearity
    nl = ifft(ψ)
    nl = (real(nl).^2 + imag(nl).^2) .* nl
    fft!(nl)

    dψ = - im .* (ϵ + g .* nl - (ω² .+ (vb * k).^2) .* ψ) - γ * ψ

    # alias
    dψ[N÷3:2*N÷3] = zeros(N÷3+1)

    du .= [real(dψ); imag(dψ)];
end


const n = 64
const ω² = 0.45
const g = 2.0
const γ = 0.01
const vb = 0.9
const ϵ₀ = 0.3
const Δt = 0.1
const tf = 1.0e6

ψ₀ = Array{Complex{Float64},1}(undef, n)
u₀ = Array{Float64,1}(undef, 2*n)

# ϵ in fourier space
ϵ = ones(n) * ϵ₀ + zeros(n) * im;
fft!(ϵ);

# wave number vector
k = Vector{Float64}(undef, n);
ψ₀ = zeros()

for i in 1: n÷2+1
    k[i] = float(i-1);
end
for i in n÷2+2: n
    k[i] = float(-(n-(i-1)));
end

p = [ϵ, g, ω², vb, γ, k];
tspan = (0, tf);

for i in 1:50

    # initial condition
    ψ₀ = ones(n) * 1.0e-5 + zeros(n) * im;
    ψ₀[1] = rand();
    ψ₀[2] = 0.1 * rand();
    ψ₀[end] = ψ₀[2];
    ψ₀[3] = 0.01 * rand();
    ψ₀[end-1] = ψ₀[3];

    u₀ = [real(ψ₀); imag(ψ₀)];


    prob = ODEProblem(fex!, u₀, tspan, p);
    sol = solve(prob, AutoTsit5(Rosenbrock23()),
                reltol=1e-8, abstol=1e-8, saveat=Δt);

    f = open(string("nlse_", repr(rand())[3:7], ".dat"), "w")

    for i in 1:length(sol)
        ϕ = sol[i][1:n] + im * sol[i][(n+1):end]
        ifft!(ϕ)
        M = real(mean(abs2.(ϕ)))
        write(f, "$(sol.t[i]) $(M)\n")
    end

    # plot(sol.t, M)

    close(f)
end

# plot(t, M)
