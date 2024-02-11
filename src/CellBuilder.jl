module CellBuilder

include("index_generator.jl")
include("elements.jl")
include("cellcalculator.jl")
include("io.jl")

function transform_cel(
    input::String,
    output::String,
    zone_axis::Vector;
    tolerance::Real = 1,
    max_iterations::Int = 1_000_000,
    max_index::Int = 100
    )
    cell_parameters, basis = load_cell(input)
    CoBmatrix = find_orthogonal_cell(
        zone_axis, 
        cell_parameters, 
        tolerance=tolerance,
        maximum_iterations=max_iterations, 
        maximum_index=max_index
    )
    new_basis = transform_basis(basis, CoBmatrix)
    new_cell_parameters = transform_cell_parameters(cell_parameters, CoBmatrix)
    save_cell(output, new_cell_parameters, new_basis) 
end
end
