module TypeTraits

export @trait, @mixin

# global registry of all abstract classes defined
traits_declarations = Dict{Symbol, Array}()

# @trait type X
# ...
# end
macro trait(typedef)
  # TODO: add checks that no inheritance occurs here

  sym = typedef.args[2]
  block = typedef.args[3]

  traits_declarations[sym] = [Expr(:(::), var.args[1], var.args[2]) for var in block.args[2:2:end]]
end

# @mixin type Foo(X) <: Y end
macro mixin(typedef)
  decl = typedef.args[2]
  block = typedef.args[3]

  if decl.head === :call
    sym = decl.args[1]
    mixin = decl.args[2]
    parent = None
  elseif decl.head === :<:
    traits = decl.args[1]
    sym = traits.args[1]
    mixin = traits.args[2]
    parent = decl.args[2]
  end

  trait_declaration = traits_declarations[mixin]
  child_declarations = [Expr(:(::), var.args[1], var.args[2]) for var in block.args[2:2:end]]
  declarations = vcat(trait_declaration, child_declarations)

  if parent !== None
    Expr(:type, true, Expr(:<:, esc(sym), esc(parent)), Expr(:block, declarations...))
  else
    Expr(:type, true, esc(sym), Expr(:block, declarations...))
  end
end

end # module
