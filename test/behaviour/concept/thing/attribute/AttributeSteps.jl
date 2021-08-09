using Dates: length
using Base: func_for_method_checked
# This file is a part of TypeDBClient.  License is MIT: https://github.com/Humans-of-Julia/TypeDBClient.jl/blob/main/LICENSE

using Behavior
using TypeDBClient
using Dates

g = TypeDBClient

function _attribute(transaction, label::String)
    res = g.match(transaction, "match \$x type $label;")
    erg = isempty(res) ? [] : collect(Iterators.flatten([values(rm.data) for rm in res]))
    return erg
end

# Scenario: Attribute with value type boolean can be created
@given("put attribute type: is-alive, with value type: boolean") do context
    res = _put_attribute_to_db(context, "is-alive", g.Proto.AttributeType_ValueType.BOOLEAN)
    @expect typeof(res) == g.Proto.Transaction_Res
    @expect typeof(res.concept_manager_res) == g.Proto.ConceptManager_Res
    @expect typeof(res.concept_manager_res.put_attribute_type_res) == g.Proto.ConceptManager_PutAttributeType_Res
end

@given("put attribute type: age, with value type: long") do context
    _put_attribute_to_db(context, "age", g.Proto.AttributeType_ValueType.LONG)
end

@given("put attribute type: score, with value type: double") do context
    _put_attribute_to_db(context, "score", g.Proto.AttributeType_ValueType.DOUBLE)
end

@given("put attribute type: birth-date, with value type: datetime") do context
    _put_attribute_to_db(context, "birth-date", g.Proto.AttributeType_ValueType.DATETIME)
end

@given("put attribute type: name, with value type: string") do context
    _put_attribute_to_db(context, "name", g.Proto.AttributeType_ValueType.STRING)
end

@given("put attribute type: email, with value type: string") do context
    _put_attribute_to_db(context, "email", g.Proto.AttributeType_ValueType.STRING)
end

@given("attribute(email) as(string) set regex: \\S+@\\S+\\.\\S+") do context
    cm = g.ConceptManager(context[:transaction])
    res = get(cm, g.AttributeType, "email")
    res_rem = g.as_remote(res, context[:transaction])
    res_regex = g.set_regex(res_rem, raw"\S+@\S+\.\S+")
end

@when("\$x = attribute(is-alive) as(boolean) put: true") do context
    ins_string = "insert
    \$x isa is-alive;
    \$x true;"
    res = g.insert(context[:transaction], ins_string)
    context[:x] = res[1].data["x"]
end

@then("attribute \$x is null: false") do context
    @expect context[:x] !== nothing
end

@then("attribute \$x has type: is-alive") do context
    @expect context[:x].type.label.name == "is-alive"
end

@then("attribute \$x has value type: boolean") do context
    @expect typeof(context[:x].value) == Bool
end

@then("attribute \$x has boolean value: true") do context
    @expect typeof(context[:x].value) == Bool
    @expect context[:x].value === true
end

@when("\$x = attribute(is-alive) as(boolean) get: true") do context
    @expect context[:x].type.label.name == "is-alive"
    @expect context[:x].value === true
end

# Scenario: Attribute with value type long can be created

@when("\$x = attribute(age) as(long) put: 21") do context
    ins_string = "insert
    \$x isa age;
    \$x 21;"
    res = g.insert(context[:transaction], ins_string)

    context[:x] = res[1].data["x"]
end

@then("attribute \$x has type: age") do context
    erg = context[:x]
    @expect erg.type.label.name == "age"
end

@then("attribute \$x has value type: long") do context
    erg = context[:x]
    @expect erg.type == g.AttributeType(g.Label("","age"), false, VALUE_TYPE.LONG)
    @expect typeof(erg.value) == Int64
end

@then("attribute \$x has long value: 21") do context
    erg = context[:x]
    @expect typeof(erg.value) == Int64
    @expect erg.value == 21
end

@when("\$x = attribute(age) as(long) get: 21") do context
    @expect context[:x].value == 21
end

#  Scenario: Attribute with value type double can be created
@when("\$x = attribute(score) as(double) put: 123.456") do context
    ins_string = "insert
    \$x isa score;
    \$x 123.456;"
    res = g.insert(context[:transaction], ins_string)
    context[:x] = res[1].data["x"]
end

@then("attribute \$x has type: score") do context
    erg = context[:x]
    @expect erg.type.label.name == "score"
end

@then("attribute \$x has value type: double") do context
    erg = context[:x]
    @expect erg.type == g.AttributeType(g.Label("","score"), false, VALUE_TYPE.DOUBLE)
    @expect typeof(erg.value) == Float64
end

@then("attribute \$x has double value: 123.456") do context
    erg = context[:x]
    @expect typeof(erg.value) == Float64
    @expect erg.value == 123.456
end


# Scenario: Attribute with value type string can be created
@when("\$x = attribute(name) as(string) put: alice") do context
    ins_string = raw"""insert $x isa name; $x "alice";"""
    res = g.insert(context[:transaction], ins_string)
    context[:x] = res[1].data["x"]
end

@then("attribute \$x has type: name") do context
    erg = context[:x]

    @expect erg.type.label.name == "name"
end

@then("attribute \$x has value type: string") do context
    erg = context[:x]
    @expect typeof(erg.value) == String
end

@then("attribute \$x has string value: alice") do context
    erg = context[:x]
    @expect typeof(erg.value) == String
    @expect erg.value == "alice"
end

@when("\$x = attribute(name) as(string) get: alice") do context
    @expect context[:x].value == "alice"
end

# Scenario: Attribute with value type string and satisfies a regular expression can be created

@when("\$x = attribute(email) as(string) put: alice@email.com") do context
    ins_string = raw"""insert $x isa email; $x "alice@email.com";"""
    context[:x] =  g.insert(context[:transaction], ins_string)[1].data["x"]
end

@then("attribute \$x has type: email") do context
    @expect context[:x].type.label.name == "email"
end

@then("attribute \$x has string value: alice@email.com") do context
    @expect context[:x].value == "alice@email.com"
end

@when("\$x = attribute(email) as(string) get: alice@email.com") do context
    @expect typeof(context[:x].value) == String
    @expect context[:x].value == "alice@email.com"
end

# Scenario: Attribute with value type string but does not satisfy a regular expression cannot be created
@when("attribute(email) as(string) put: alice-email-com; throws exception") do context
    ins_string = raw"""insert $x isa email; $x "alice-email-com";"""
    try
        g.insert(context[:transaction], ins_string)
    catch ex
        @expect ex !== nothing
    end
end

#  Scenario: Attribute with value type datetime can be created
@when("\$x = attribute(birth-date) as(datetime) put: 1990-01-01 11:22:33") do context
    ins_string = raw"""insert $x isa birth-date; $x 1990-01-01T11:22:33;"""
    res = g.insert(context[:transaction], ins_string)
    context[:x] = res[1].data["x"]
end

@then("attribute \$x has type: birth-date") do context
    erg = context[:x]

    @expect erg.type.label.name == "birth-date"
end

@then("attribute \$x has value type: datetime") do context
    erg = context[:x]
    @expect typeof(erg.value) == Int64
end

@then("attribute \$x has datetime value: 1990-01-01 11:22:33") do context
    erg = context[:x]
    @expect typeof(erg.value) == Int64
    @expect unix2datetime(erg.value / 1000) == parse(DateTime,"1990-01-01T11:22:33")
end

@when("\$x = attribute(birth-date) as(datetime) get: 1990-01-01 11:22:33") do context
    erg = context[:x]
    @expect erg.type.label.name == "birth-date"
    @expect typeof(erg.value) == Int64
    @expect unix2datetime(erg.value / 1000) == parse(DateTime,"1990-01-01T11:22:33")
end

# Scenario: Attribute with value type boolean can be retrieved from its type
@then("attribute(is-alive) get instances contain: \$x") do context
    erg = _attribute_instances(context[:transaction])[1]
    @expect erg.type == g.AttributeType(g.Label("","is-alive"), false, VALUE_TYPE.BOOLEAN)
end

# Scenario: Attribute with value type long can be retrieved from its type
@then("attribute(age) get instances contain: \$x") do context
    attr = g.get(context[:cm], AttributeType, "age")
    erg = g.get_instances(g.as_remote(attr, context[:transaction]))[1]
    @expect erg.type == g.AttributeType(g.Label("","age"), false, VALUE_TYPE.LONG)
end

# Scenario: Attribute with value type double can be retrieved from its type
@then("attribute(score) get instances contain: \$x") do context
    attr = g.get(context[:cm], AttributeType, "score")
    erg = g.get_instances(g.as_remote(attr, context[:transaction]))[1]
    @expect erg.type == g.AttributeType(g.Label("","score"), false, VALUE_TYPE.DOUBLE)
end

# Scenario: Attribute with value type string can be retrieved from its type
@then("attribute(name) get instances contain: \$x") do context
    attr = g.get(context[:cm], AttributeType, "name")
    res = g.get_instances(g.as_remote(attr, context[:transaction]))[1]
    @expect res.type == g.AttributeType(g.Label("","name"), false, VALUE_TYPE.STRING)
end

# Scenario: Attribute with value type datetime can be retrieved from its type
@then("attribute(birth-date) get instances contain: \$x") do context
    attr = g.get(context[:cm], AttributeType, "birth-date")
    res = g.get_instances(g.as_remote(attr, context[:transaction]))[1]
    @expect res.type == g.AttributeType(g.Label("","birth-date"), false, VALUE_TYPE.DATETIME)
end

# Scenario: Attribute with value type boolean can be deleted
@when("delete attribute: \$x") do context
    del_string = raw"""match $x isa attribute; delete $x isa attribute;"""
    g.delete(context[:transaction], del_string)
end

@then("attribute \$x is deleted: true") do context
    erg = _attribute_instances(context[:transaction])
    @expect length(erg) == 0
end

@then("attribute \$x is null: true") do context
    erg = _attribute_instances(context[:transaction])
    @expect length(erg) == 0
end

# Scenario: Attribute with value type double can be deleted
@when("\$x = attribute(score) as(double) get: 123.456") do context
    @expect context[:x].value == 123.456
end

# Scenario: Attribute with value type double is assignable and retrievable from a 'long' value
@when("\$x = attribute(score) as(double) put: 123") do context
    ins_string = raw"""insert $x isa score; $x 123;"""
    res = g.insert(context[:transaction], ins_string)
    context[:x] = res[1].data["x"]
end

@then("attribute \$x has double value: 123") do context
    erg = context[:x]
    @expect erg.value == 123
end

@when("\$x = attribute(score) as(double) get: 123") do context
    erg = _attribute_instances(context[:transaction])
    context[:x] = erg[1]
end
