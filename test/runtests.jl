using Test
using IncidenceGraphs
using Graphs
using SparseArrays

# Test the creation of an empty IncidenceGraph
function test_empty_IncidenceGraph()
    g = IncidenceGraph()
    @test nv(g) == 0
    @test ne(g) == 0
end

# Test the creation of an IncidenceGraph from an incidence matrix
function test_IncidenceGraph_from_matrix()
    incidence_matrix = sparse(Int[1 0 0; 1 1 0; 0 1 1; 0 0 1; 0 0 0])
    g = IncidenceGraph(incidence_matrix)
    @test nv(g) == 5
    @test ne(g) == 3
    @test vertices(g) == [1, 2, 3, 4, 5]
    @test g[1, 1] == true
    @test g[2, 1] == true
    @test g[2, 2] == true
    @test g[3, 2] == true
    @test g[3, 3] == true
    @test g[4, 3] == true
end

# Test the zero function
function test_zero_IncidenceGraph()
    g = zero(IncidenceGraph{Int})
    @test nv(g) == 0
    @test ne(g) == 0
end

# Test the is_directed function
function test_is_directed_IncidenceGraph()
    @test is_directed(IncidenceGraph) == false
end

# Test the setindex! function
function test_setindex_IncidenceGraph()
    g = IncidenceGraph(sparse([1 0 0; 1 1 0; 0 1 1; 0 0 1]))
    g[2, 1] = true
    @test g[2, 1] == true
end

# Test add_vertex! function
function test_add_vertex!()
    g = IncidenceGraph{Int}()
    Graphs.add_vertex!(g)
    @test nv(g) == 1
    Graphs.add_vertex!(g)
    @test nv(g) == 2
end

function test_add_edge!()
    g = IncidenceGraph{Int}()
    Graphs.add_edge!(g, 1, 2)
    @test has_vertex(g, 1)
    @test has_vertex(g, 2)
    @test has_edge(g, 1, 2)
    @test has_edge(g, 2, 1)
    @test !has_edge(g, 1, 3)
end

# Test neighbors function
function test_neighbors()
    g = IncidenceGraph{Int}()
    Graphs.add_vertex!(g)
    Graphs.add_vertex!(g)
    Graphs.add_edge!(g, 1, 2)
    @test Graphs.neighbors(g, 1) == [2]
    @test Graphs.neighbors(g, 2) == [1]
end

# Run all the tests
@testset "Unit tests" verbose = true begin
    test_empty_IncidenceGraph()
    test_IncidenceGraph_from_matrix()
    test_zero_IncidenceGraph()
    test_is_directed_IncidenceGraph()
    test_setindex_IncidenceGraph()
    test_add_vertex!()
    test_add_edge!()
    test_neighbors()
end