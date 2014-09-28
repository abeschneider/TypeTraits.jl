using TypeTraits
using Base.Test

abstract Player

@trait type Entity
  id::Int64
  x::Float64
  y::Float64
end

@mixin type User(Entity) <: Player
  name::String
end

function User(name::String)
  User(0, 0, 0, name)
end


user = User("Foobar")
println(user)
