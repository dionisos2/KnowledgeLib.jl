mutable struct MyObject{T <: AbstractString} <: AbstractString
    prop::T
    function MyObject{T}(prop::T) where (T <: AbstractString)
        tmp = new{T}()
        setfield!(tmp, :prop, prop * "plop")
        return tmp
    end
end

MyObject() = MyObject{String}("plop")

Base.getproperty(myobject::MyObject, sym::Symbol) = return _getproperty(myobject, Val(sym))
_getproperty(myobject::MyObject, ::Val{sym}) where {sym} = getfield(myobject, sym)
Base.setproperty!(myobject::MyObject, sym::Symbol, value) = _setproperty!(myobject, Val(sym), value)
_setproperty!(myobject::MyObject, ::Val{sym}, value) where {sym} = setfield!(myobject, sym, value)

_setproperty!(myobject::MyObject, ::Val{:prop}, value) = error("MyObject.prop is a private member")
