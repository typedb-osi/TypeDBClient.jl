# This file is a part of GraknClient.  License is MIT: https://github.com/Humans-of-Julia/GraknClient.jl/blob/main/LICENSE 

# 
# package grakn.client.concept.thing;
# 
# import grakn.client.api.Transaction;
# import grakn.client.api.concept.thing.Attribute;
# import grakn.client.api.concept.thing.Thing;
# import grakn.client.api.concept.type.AttributeType;
# import grakn.client.api.concept.type.RoleType;
# import grakn.client.common.GraknClientException;
# import grakn.client.concept.ConceptImpl;
# import grakn.client.concept.type.RoleTypeImpl;
# import grakn.client.concept.type.ThingTypeImpl;
# import grakn.protocol.ConceptProto;
# import grakn.protocol.TransactionProto;
# 
# import java.util.Objects;
# import java.util.stream.Stream;
# 
# import static grakn.client.common.ErrorMessage.Concept.BAD_ENCODING;
# import static grakn.client.common.ErrorMessage.Concept.MISSING_IID;
# import static grakn.client.common.ErrorMessage.Concept.MISSING_TRANSACTION;
# import static grakn.client.common.RequestBuilder.Thing.deleteReq;
# import static grakn.client.common.RequestBuilder.Thing.getHasReq;
# import static grakn.client.common.RequestBuilder.Thing.getPlaysReq;
# import static grakn.client.common.RequestBuilder.Thing.getRelationsReq;
# import static grakn.client.common.RequestBuilder.Thing.isInferredReq;
# import static grakn.client.common.RequestBuilder.Thing.protoThing;
# import static grakn.client.common.RequestBuilder.Thing.setHasReq;
# import static grakn.client.common.RequestBuilder.Thing.unsetHasReq;
# import static grakn.client.concept.type.TypeImpl.protoTypes;
# import static grakn.common.util.Objects.className;
# import static java.util.Arrays.asList;
# 
# public abstract class ThingImpl extends ConceptImpl implements Thing {
# 
#     private final String iid;
# 
#     ThingImpl(String iid) {
#         if (iid == null || iid.isEmpty()) throw new GraknClientException(MISSING_IID);
#         this.iid = iid;
#     }
# 
#     public static ThingImpl of(ConceptProto.Thing thingProto) {
#         switch (thingProto.getType().getEncoding()) {
#             case ENTITY_TYPE:
#                 return EntityImpl.of(thingProto);
#             case RELATION_TYPE:
#                 return RelationImpl.of(thingProto);
#             case ATTRIBUTE_TYPE:
#                 return AttributeImpl.of(thingProto);
#             case UNRECOGNIZED:
#             default:
#                 throw new GraknClientException(BAD_ENCODING.message(thingProto.getType().getEncoding()));
#         }
#     }
# 
#     @Override
#     public final String getIID() {
#         return iid;
#     }
# 
#     @Override
#     public abstract ThingTypeImpl getType();
# 
#     @Override
#     public ThingImpl asThing() {
#         return this;
#     }
# 
#     @Override
#     public String toString() {
#         return className(this.getClass()) + "[iid:" + iid + "]";
#     }
# 
#     @Override
#     public boolean equals(Object o) {
#         if (this == o) return true;
#         if (o == null || getClass() != o.getClass()) return false;
# 
#         ThingImpl that = (ThingImpl) o;
#         return (this.iid.equals(that.iid));
#     }
# 
#     @Override
#     public int hashCode() {
#         return iid.hashCode();
#     }
# 
#     public abstract static class Remote extends ConceptImpl.Remote implements Thing.Remote {
# 
#         final Transaction.Extended transactionRPC;
#         private final String iid;
#         private final int hash;
# 
#         Remote(Transaction transaction, String iid) {
#             if (transaction == null) throw new GraknClientException(MISSING_TRANSACTION);
#             this.transactionRPC = (Transaction.Extended) transaction;
#             if (iid == null || iid.isEmpty()) throw new GraknClientException(MISSING_IID);
#             this.iid = iid;
#             this.hash = Objects.hash(this.transactionRPC, this.getIID());
#         }
# 
#         @Override
#         public final String getIID() {
#             return iid;
#         }
# 
#         @Override
#         public abstract ThingTypeImpl getType();
# 
#         @Override
#         public final boolean isInferred() {
#             return execute(isInferredReq(getIID())).getThingIsInferredRes().getInferred();
#         }
# 
#         @Override
#         public final Stream<AttributeImpl<?>> getHas(AttributeType... attributeTypes) {
#             return stream(getHasReq(getIID(), protoTypes(asList(attributeTypes))))
#                     .flatMap(rp -> rp.getThingGetHasResPart().getAttributesList().stream())
#                     .map(AttributeImpl::of);
#         }
# 
#         @Override
#         public final Stream<AttributeImpl.Boolean> getHas(AttributeType.Boolean attributeType) {
#             return getHas((AttributeType) attributeType).map(AttributeImpl::asBoolean);
#         }
# 
#         @Override
#         public final Stream<AttributeImpl.Long> getHas(AttributeType.Long attributeType) {
#             return getHas((AttributeType) attributeType).map(AttributeImpl::asLong);
#         }
# 
#         @Override
#         public final Stream<AttributeImpl.Double> getHas(AttributeType.Double attributeType) {
#             return getHas((AttributeType) attributeType).map(AttributeImpl::asDouble);
#         }
# 
#         @Override
#         public final Stream<AttributeImpl.String> getHas(AttributeType.String attributeType) {
#             return getHas((AttributeType) attributeType).map(AttributeImpl::asString);
#         }
# 
#         @Override
#         public final Stream<AttributeImpl.DateTime> getHas(AttributeType.DateTime attributeType) {
#             return getHas((AttributeType) attributeType).map(AttributeImpl::asDateTime);
#         }
# 
#         @Override
#         public final Stream<AttributeImpl<?>> getHas(boolean onlyKey) {
#             return stream(getHasReq(getIID(), onlyKey))
#                     .flatMap(rp -> rp.getThingGetHasResPart().getAttributesList().stream())
#                     .map(AttributeImpl::of);
#         }
# 
#         @Override
#         public final Stream<RoleTypeImpl> getPlays() {
#             return stream(getPlaysReq(getIID()))
#                     .flatMap(rp -> rp.getThingGetPlaysResPart().getRoleTypesList().stream())
#                     .map(RoleTypeImpl::of);
#         }
# 
#         @Override
#         public final Stream<RelationImpl> getRelations(RoleType... roleTypes) {
#             return stream(getRelationsReq(getIID(), protoTypes(asList(roleTypes))))
#                     .flatMap(rp -> rp.getThingGetRelationsResPart().getRelationsList().stream())
#                     .map(RelationImpl::of);
#         }
# 
#         @Override
#         public final void setHas(Attribute<?> attribute) {
#             execute(setHasReq(getIID(), protoThing(attribute.getIID())));
#         }
# 
#         @Override
#         public final void unsetHas(Attribute<?> attribute) {
#             execute(unsetHasReq(getIID(), protoThing(attribute.getIID())));
#         }
# 
#         @Override
#         public final void delete() {
#             execute(deleteReq(getIID()));
#         }
# 
#         @Override
#         public final boolean isDeleted() {
#             return transactionRPC.concepts().getThing(getIID()) == null;
#         }
# 
#         @Override
#         public final ThingImpl.Remote asThing() {
#             return this;
#         }
# 
#         protected ConceptProto.Thing.Res execute(TransactionProto.Transaction.Req.Builder request) {
#             return transactionRPC.execute(request).getThingRes();
#         }
# 
#         protected Stream<ConceptProto.Thing.ResPart> stream(TransactionProto.Transaction.Req.Builder request) {
#             return transactionRPC.stream(request).map(TransactionProto.Transaction.ResPart::getThingResPart);
#         }
# 
#         @Override
#         public String toString() {
#             return className(this.getClass()) + "[iid:" + iid + "]";
#         }
# 
#         @Override
#         public boolean equals(Object o) {
#             if (this == o) return true;
#             if (o == null || getClass() != o.getClass()) return false;
# 
#             ThingImpl.Remote that = (ThingImpl.Remote) o;
#             return this.transactionRPC.equals(that.transactionRPC) && this.iid.equals(that.iid);
#         }
# 
#         @Override
#         public int hashCode() {
#             return hash;
#         }
#     }
# }
