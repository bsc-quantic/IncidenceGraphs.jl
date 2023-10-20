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
Graphs.has_self_loops(::IncidenceGraph) = false

Graphs.nv(g::IncidenceGraph) = size(g.incidence_matrix, 1)
Graphs.ne(g::IncidenceGraph) = size(g.incidence_matrix, 2) # TODO or filter(count > 0, dim=1) ?
Graphs.vertices(g::IncidenceGraph) = collect(1:nv(g))

Base.zero(::Type{IncidenceGraph{T}}) where {T} = IncidenceGraph{T}()

Base.getindex(g::IncidenceGraph, args...; kwargs...) = getindex(g.incidence_matrix, args...; kwargs...)
Base.setindex!(g::IncidenceGraph, args...; kwargs...) = setindex!(g.incidence_matrix, args...; kwargs...)

function Graphs.add_vertex!(g::IncidenceGraph{T}) where {T}
    addrow!(g.incidence_matrix, size(g.incidence_matrix, 1) + 1, T[1, 1], T[1, 0])
end

function Graphs.add_edge!(g::IncidenceGraph, vs...)
    e = size(g.incidence_matrix, 2) + 1
    for v in vs
        g.incidence_matrix[v, e] = 1
    end
end

Graphs.has_vertex(g::IncidenceGraph, v) = v ∈ axes(g.incidence_matrix)[1]

function Graphs.has_edge(g::IncidenceGraph, vs...)
    edges = SparseArrays.nonzeroinds(g.incidence_matrix[first(vs), :])
    any(edges) do edge
        issetequal(vs, SparseArrays.nonzeroinds(g.incidence_matrix[:, edge]))
    end
end

function Graphs.neighbors(g::IncidenceGraph, v::Integer)
    edges = SparseArrays.nonzeroinds(g[v, :])
    mapreduce(∪, edges) do edge
        filter(!=(v), SparseArrays.nonzeroinds(g[:, edge]))
    end
end

end
