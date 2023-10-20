module IncidenceGraphs

using DynamicSparseArrays
using Graphs
using SparseArrays

export IncidenceGraph

mutable struct IncidenceGraph{T} <: AbstractGraph{T}
    incidence_matrix::DynamicSparseMatrix{T,T,Int}

    IncidenceGraph{T}() where {T} = new{T}(dynamicsparse(T, T, Int; fill_mode=false))
    function IncidenceGraph(incidence_matrix::AbstractSparseMatrix{Int,T}) where {T}
        new{T}(dynamicsparse(findnz(incidence_matrix)..., size(incidence_matrix)...))
    end
end

IncidenceGraph() = IncidenceGraph{Int}()

Graphs.is_directed(::Type{<:IncidenceGraph}) = false

Graphs.nv(g::IncidenceGraph) = size(g.incidence_matrix, 1)
Graphs.ne(g::IncidenceGraph) = size(g.incidence_matrix, 2) # TODO or filter(count > 0, dim=1) ?
Graphs.vertices(g::IncidenceGraph) = collect(1:nv(g))

Base.zero(::Type{IncidenceGraph{T}}) where {T} = IncidenceGraph{T}()

Base.getindex(g::IncidenceGraph, args...; kwargs...) = getindex(g.incidence_matrix, args...; kwargs...)
Base.setindex!(g::IncidenceGraph, args...; kwargs...) = setindex!(g.incidence_matrix, args...; kwargs...)

end
