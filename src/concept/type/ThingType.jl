# This file is a part of TypeDBClient.  License is MIT: https://github.com/Humans-of-Julia/TypeDBClient.jl/blob/main/LICENSE

struct ThingType <: AbstractThingType
    label::Label
    is_root::Bool
end

# Porting note: Java client calls into RequestBuilder but it really
# has nothing to to with requests... I think it's probably better
# migrating the function here.
function proto(t::AbstractThingType)
    Proto._Type(
        label=t.label.name,
        encoding=encoding(t)
    )
    # return ThingTypeRequestBuilder.proto_thing_type(t.label, encoding(t))
end

# a convinient function to prevent code to work around a argument nothing
proto(t::Nothing) = t

# Contract: all subtypes of AbstractThingType should have these two fields
is_root(t::AbstractThingType) = t.is_root
label(t::AbstractThingType) = t.label

# ------------------------------------------------------------------------
# Remote functions
# ------------------------------------------------------------------------

function set_supertype(r::RemoteConcept{C,T},
                        super_type::AbstractThingType) where
                        {C <: AbstractThingType, T <: AbstractCoreTransaction}

    req = ThingTypeRequestBuilder.set_supertype_req(r.concept.label, proto(super_type))
    execute(r.transaction, req)
end

function get_supertype(r::RemoteConcept{C,T}) where {C <: AbstractType,T <: AbstractCoreTransaction}
    req = TypeRequestBuilder.get_supertype_req(r.concept.label)
    res = execute(r.transaction, req)
    typ = res.type_res.type_get_supertype_res._type
    return instantiate(typ)
end

function get_supertypes(r::RemoteConcept{C,T}) where {C <: AbstractType,T <: AbstractCoreTransaction}
    req = TypeRequestBuilder.get_supertypes_req(r.concept.label)
    res = execute(r.transaction, req)
    typs = res.type_res_part.type_get_supertypes_res_part.types
    return instantiate.(typs)
end

function get_subtypes(r::RemoteConcept{C,T}) where {C <: AbstractType,T <: AbstractCoreTransaction}
    req = TypeRequestBuilder.get_subtypes_req(r.concept.label)
    res = execute(r.transaction, req)
    typs = res.type_res_part.type_get_subtypes_res_part.types
    return instantiate.(typs)
end

function get_instances(r::RemoteConcept{C,T}) where {C <: AbstractThingType,T <: AbstractCoreTransaction}
    req = ThingTypeRequestBuilder.get_instances_req(r.concept.label)
    res = stream(r.transaction, req)
    return instantiate.(collect(Iterators.flatten(
        r.type_res_part.thing_type_get_instances_res_part.things for r in res)))
end

function set_abstract(r::RemoteConcept{C,T}) where {C <: AbstractThingType,T <: AbstractCoreTransaction}
    req = ThingTypeRequestBuilder.set_abstract_req(r.concept.label)
    execute(r.transaction, req)
end

function unset_abstract(r::RemoteConcept{C,T}) where {C <: AbstractThingType,T <: AbstractCoreTransaction}
    req = ThingTypeRequestBuilder.unset_abstract_req(r.concept.label)
    execute(r.transaction, req)
end

function is_abstract(r::RemoteConcept{C,T}) where {C <: AbstractType,T <: AbstractCoreTransaction}
    req = TypeRequestBuilder.is_abstract_req(r.concept.label)
    res = execute(r.transaction, req)
    return res.type_res.type_is_abstract_res._abstract
end

function set_plays(
    r::RemoteConcept{C,T},
    role_type::AbstractRoleType,
    overridden_role_type::Optional{AbstractRoleType}=nothing
) where {C <: AbstractThingType,T <: AbstractCoreTransaction}
    req = ThingTypeRequestBuilder.set_plays_req(
        r.concept.label,
        proto(role_type),
        proto(overridden_role_type)
    )
    execute(r.transaction, req)
end

function unset_plays(r::RemoteConcept{C,T},
    role_type::AbstractRoleType
) where {C <: AbstractThingType,T <: AbstractCoreTransaction}
    unset_req = ThingTypeRequestBuilder.unset_plays_req(r.concept.label, proto(role_type))
    execute(r.transaction, unset_req)
end

function set_owns(
    r::RemoteConcept{C,T},
    attribute_type::AbstractType,
    is_key::Bool= false,
    overriden_type::Optional{AbstractType}= nothing
) where {C <: AbstractType,T <: AbstractCoreTransaction}
    req = ThingTypeRequestBuilder.set_owns_req(
        r.concept.label,
        is_key,
        proto(attribute_type),
        proto(overriden_type)
    )
    execute(r.transaction, req)
end

function unset_owns(
    r::RemoteConcept{C,T},
    attribute_type::AbstractType
) where {C <: AbstractType,T <: AbstractCoreTransaction}
    req = ThingTypeRequestBuilder.unset_owns_req(
        r.concept.label,
        proto(attribute_type)
    )
    execute(r.transaction, req)
end

function get_owns(
    r::RemoteConcept{C,T},
    value_type::Optional{EnumType}=nothing,
    keys_only::Bool=false
) where {C <: AbstractThingType,T <: AbstractCoreTransaction}
    req = ThingTypeRequestBuilder.get_owns_req(r.concept.label, value_type, keys_only)
    res = stream(r.transaction, req)
    return instantiate.(collect(Iterators.flatten(
        r.type_res_part.thing_type_get_owns_res_part.attribute_types for r in res)))
end

function get_plays(r::RemoteConcept{C,T}) where {C <: AbstractThingType,T <: AbstractCoreTransaction}
    req = ThingTypeRequestBuilder.get_plays_req(r.concept.label)
    res = stream(r.transaction, req)
    return instantiate.(collect(Iterators.flatten(
        r.type_res_part.thing_type_get_plays_res_part.roles for r in res)))
end

function set_label(r::RemoteConcept{C,T}, new_label_name::String) where {C <: AbstractType, T <: AbstractCoreTransaction}
    set_label_req = TypeRequestBuilder.set_label_req(r.concept.label, new_label_name)
    execute(r.transaction, set_label_req)

    return nothing
end

function delete(r::RemoteConcept{C,T}) where {C <: AbstractThingType,T <: AbstractCoreTransaction}
    del_req = TypeRequestBuilder.delete_req(r.concept.label)
    execute(r.transaction, del_req)
end
