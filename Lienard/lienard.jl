#!/usr/bin/julia

###############################################################################
#                                   LIENARD                                   #
###############################################################################

using DifferentialEquations
using Plots
using Random

function fex!(du, u, p, t)
    α, β, γ, ω, A = p

    du[1] = u[2]
    du[2] = - α * u[1] * u[2] - γ * u[1] - β * u[1]^3 + A * sin(ω * t)
end

const NEQ = 2
const α = 0.45
const β = 0.50
const γ = -0.50
const ω = 0.7315
const A = 0.2
const tf = 20000.0
const Δt = 0.01

p = [α, β, γ, ω, A]
tspan = (0.0, tf)

for i in 1:50
    u₀ = rand(NEQ)
    prob = ODEProblem(fex!, u₀, tspan, p);
    sol = solve(prob, AutoTsit5(Rosenbrock23()),
                reltol=1e-8, abstol=1e-8, saveat=Δt);

    f = open(string("lienard_", repr(rand())[3:7], ".dat"), "w")
    for i in 1:length(sol)
        write(f, "$(sol.t[i]) $(sol[i][2])\n")
    end
    close(f)
end


# plot(sol, vars=(0,2))
