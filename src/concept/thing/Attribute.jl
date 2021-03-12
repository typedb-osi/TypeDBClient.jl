# This file is a part of GraknClient.  License is MIT: https://github.com/Humans-of-Julia/GraknClient.jl/blob/main/LICENSE

# from datetime import datetime

# import grakn_protocol.protobuf.concept_pb2 as concept_proto

# from grakn.concept.proto import concept_proto_builder, concept_proto_reader
# from grakn.concept.thing.thing import Thing, RemoteThing


# class Attribute(Thing):

#     def is_attribute(self):
#         return True

#     def is_boolean(self):
#         return False

#     def is_long(self):
#         return False

#     def is_double(self):
#         return False

#     def is_string(self):
#         return False

#     def is_datetime(self):
#         return False


# class RemoteAttribute(RemoteThing):

#     def get_owners(self, owner_type=None):
#         method = concept_proto.Thing.Req()
#         get_owners_req = concept_proto.Attribute.GetOwners.Req()
#         if owner_type:
#             get_owners_req.thing_type = concept_proto_builder.type_(owner_type)
#         method.attribute_get_owners_req.CopyFrom(get_owners_req)
#         return self._thing_stream(method, lambda res: res.attribute_get_owners_res.things)

#     def is_attribute(self):
#         return True

#     def is_boolean(self):
#         return False

#     def is_long(self):
#         return False

#     def is_double(self):
#         return False

#     def is_string(self):
#         return False

#     def is_datetime(self):
#         return False


# class BooleanAttribute(Attribute):

#     def __init__(self, iid: str, type_, value: bool):
#         super(BooleanAttribute, self).__init__(iid, type_)
#         self._value = value

#     @staticmethod
#     def _of(thing_proto: concept_proto.Thing):
#         return BooleanAttribute(concept_proto_reader.iid(thing_proto.iid), concept_proto_reader.attribute_type(thing_proto.type), thing_proto.value.boolean)

#     def get_value(self):
#         return self._value

#     def is_boolean(self):
#         return True

#     def as_remote(self, transaction):
#         return RemoteBooleanAttribute(transaction, self.get_iid(), self.get_type(), self.get_value())


# class RemoteBooleanAttribute(RemoteAttribute):

#     def __init__(self, transaction, iid: str, type_, value: bool):
#         super(RemoteBooleanAttribute, self).__init__(transaction, iid, type_)
#         self._value = value

#     def get_value(self):
#         return self._value

#     def is_boolean(self):
#         return True

#     def as_remote(self, transaction):
#         return RemoteBooleanAttribute(transaction, self.get_iid(), self.get_type(), self.get_value())


# class LongAttribute(Attribute):

#     def __init__(self, iid: str, type_, value: int):
#         super(LongAttribute, self).__init__(iid, type_)
#         self._value = value

#     @staticmethod
#     def _of(thing_proto: concept_proto.Thing):
#         return LongAttribute(concept_proto_reader.iid(thing_proto.iid), concept_proto_reader.attribute_type(thing_proto.type), thing_proto.value.long)

#     def get_value(self):
#         return self._value

#     def is_long(self):
#         return True

#     def as_remote(self, transaction):
#         return RemoteLongAttribute(transaction, self.get_iid(), self.get_type(), self.get_value())


# class RemoteLongAttribute(RemoteAttribute):

#     def __init__(self, transaction, iid: str, type_, value: int):
#         super(RemoteLongAttribute, self).__init__(transaction, iid, type_)
#         self._value = value

#     def get_value(self):
#         return self._value

#     def is_long(self):
#         return True

#     def as_remote(self, transaction):
#         return RemoteLongAttribute(transaction, self.get_iid(), self.get_type(), self.get_value())


# class DoubleAttribute(Attribute):

#     def __init__(self, iid: str, type_, value: float):
#         super(DoubleAttribute, self).__init__(iid, type_)
#         self._value = value

#     @staticmethod
#     def _of(thing_proto: concept_proto.Thing):
#         return DoubleAttribute(concept_proto_reader.iid(thing_proto.iid), concept_proto_reader.attribute_type(thing_proto.type), thing_proto.value.double)

#     def get_value(self):
#         return self._value

#     def is_double(self):
#         return True

#     def as_remote(self, transaction):
#         return RemoteDoubleAttribute(transaction, self.get_iid(), self.get_type(), self.get_value())


# class RemoteDoubleAttribute(RemoteAttribute):

#     def __init__(self, transaction, iid: str, type_, value: float):
#         super(RemoteDoubleAttribute, self).__init__(transaction, iid, type_)
#         self._value = value

#     def get_value(self):
#         return self._value

#     def is_double(self):
#         return True

#     def as_remote(self, transaction):
#         return RemoteDoubleAttribute(transaction, self.get_iid(), self.get_type(), self.get_value())


# class StringAttribute(Attribute):

#     def __init__(self, iid: str, type_, value: str):
#         super(StringAttribute, self).__init__(iid, type_)
#         self._value = value

#     @staticmethod
#     def _of(thing_proto: concept_proto.Thing):
#         return StringAttribute(concept_proto_reader.iid(thing_proto.iid), concept_proto_reader.attribute_type(thing_proto.type), thing_proto.value.string)

#     def get_value(self):
#         return self._value

#     def is_string(self):
#         return True

#     def as_remote(self, transaction):
#         return RemoteStringAttribute(transaction, self.get_iid(), self.get_type(), self.get_value())


# class RemoteStringAttribute(RemoteAttribute):

#     def __init__(self, transaction, iid: str, type_, value: str):
#         super(RemoteStringAttribute, self).__init__(transaction, iid, type_)
#         self._value = value

#     def get_value(self):
#         return self._value

#     def is_string(self):
#         return True

#     def as_remote(self, transaction):
#         return RemoteStringAttribute(transaction, self.get_iid(), self.get_type(), self.get_value())


# class DateTimeAttribute(Attribute):

#     def __init__(self, iid: str, type_, value: datetime):
#         super(DateTimeAttribute, self).__init__(iid, type_)
#         self._value = value

#     @staticmethod
#     def _of(thing_proto: concept_proto.Thing):
#         return DateTimeAttribute(concept_proto_reader.iid(thing_proto.iid), concept_proto_reader.attribute_type(thing_proto.type), datetime.fromtimestamp(float(thing_proto.value.date_time) / 1000.0))

#     def get_value(self):
#         return self._value

#     def is_datetime(self):
#         return True

#     def as_remote(self, transaction):
#         return RemoteDateTimeAttribute(transaction, self.get_iid(), self.get_type(), self.get_value())


# class RemoteDateTimeAttribute(RemoteAttribute):

#     def __init__(self, transaction, iid: str, type_, value: datetime):
#         super(RemoteDateTimeAttribute, self).__init__(transaction, iid, type_)
#         self._value = value

#     def get_value(self):
#         return self._value

#     def is_datetime(self):
#         return True

#     def as_remote(self, transaction):
#         return RemoteDateTimeAttribute(transaction, self.get_iid(), self.get_type(), self.get_value())
