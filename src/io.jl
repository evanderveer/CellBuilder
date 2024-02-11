"""
    load_cell(filename::String)
    Load cell parameters and atom positions in the unit cell from a .cel file.

    Returns a tuple containing the CellParameters and the atom positions.
"""
function load_cell(
    filename::String
    )
    if splitext(filename)[2] != ".cel"
        throw(ArgumentError("filename must be a .cel file"))
    end
    f = open(filename)
    readline(f) #Skip header line
    cell_parameters = [c for c in split(readline(f), " ") if c != ""]
    data = readdlm(f)
    close(f)
    cell_parameters = parse.(Float64, cell_parameters[2:end])
    data = data_to_matrix(data)
    return (CellParameters(cell_parameters...), data)
end

function data_to_matrix(data)
    out_data = []
    for row in eachrow(data)
        if !(lowercase(row[1]) ∈ ELEMENTS)
            continue
        end
        push!(out_data, row)
    end
    hcat(out_data...)
end

function save_cell(
    filename::String,
    cell_parameters::CellParameters,
    data::AbstractMatrix
    )
    f = open(filename, "w")
    write(f, CELL_ID_STRING)
    writedlm(f,
             permutedims([0, 
                          cell_parameters.a, 
                          cell_parameters.b, 
                          cell_parameters.c, 
                          cell_parameters.α, 
                          cell_parameters.β, 
                          cell_parameters.γ]),
             ' ')
    writedlm(f, permutedims(data))
    close(f)
end