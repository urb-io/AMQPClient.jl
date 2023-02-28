function auth_resp_amqplain(auth_params::Dict{String,Any})
    params = Dict{String,Any}("LOGIN" => auth_params["LOGIN"], "PASSWORD" => auth_params["PASSWORD"])
    iob = IOBuffer()
    write(iob, TAMQPFieldTable(params))
    bytes = take!(iob)
    skipbytes = sizeof(fieldtype(TAMQPFieldTable, :len))
    bytes = bytes[(skipbytes+1):end]
    TAMQPLongStr(bytes)
end

function auth_resp_external(auth_params::Dict{String,Any})
    TAMQPLongStr(UInt8[])
end

const AUTH_PROVIDERS = Dict{String,Function}(
    "AMQPLAIN" => auth_resp_amqplain, 
    "EXTERNAL" => auth_resp_external
)
