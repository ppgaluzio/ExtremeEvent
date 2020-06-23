#!/usr/bin/julia

###############################################################################
#                                  HR NEURONS                                 #
###############################################################################

using DifferentialEquations
using Plots
using Random


function Γ(x, λ, Θ)
    return 1.0 / (1.0 + exp(-λ * (x - Θ)))
end


function fex!(du, u, p, t)
    a, b, c, d, xr, s, I, r, vs, λ, Θ, k12 = p

    x1, y1, z1 = u[1:3]         # first neuron
    x2, y2, z2 = u[4:end]       # second neuron

    # first neuron
    du[1] = y1 + b * x1^2 - a * x1^3 - z1 + I - k12 * (x1 - vs) * Γ(x2, λ, Θ)
    du[2] = c - d * x1^2 - y1
    du[3] = r * (s * (x1 - xr) - z1)

    # second neuron
    du[4] = y2 + b * x2^2 - a * x2^3 - z2 + I - k12 * (x2 - vs) * Γ(x1, λ, Θ)
    du[5] = c - d * x2^2 - y2
    du[6] = r * (s * (x2 - xr) - z2)

end


const NNEURONS = 2
const NEQNEURONS = 3
const NEQ = NNEURONS * NEQNEURONS
const Δt = 0.01
const tf = 60000.0

const vs = 2
const λ = 10
const Θ = -0.25
const k12 = 0.07
const r = 0.01
const a = 1.0
const b = 3.0
const c = 1.0
const d = 5.0
const xr = -1.6
const s = 5.0
const I = 4.0

p = [a, b, c, d, xr, s, I, r, vs, λ, Θ, k12]
tspan = (0.0, tf)

for i in 1:50
    u₀ = rand(NEQ)
    prob = ODEProblem(fex!, u₀, tspan, p);
    sol = solve(prob, AutoTsit5(Rosenbrock23()),
                reltol=1e-8, abstol=1e-8, saveat=Δt);

    f = open(string("HR_", repr(rand())[3:7], ".dat"), "w")

    xparallel = similar(sol.t)
    for i in 1:length(sol)
        xparallel[i] = sol[i][1] + sol[i][4]
        write(f, "$(sol.t[i]) $(xparallel[i])\n")
    end
    close(f)
end
