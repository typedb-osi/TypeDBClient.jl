# This file is a part of GraknClient.  License is MIT: https://github.com/Humans-of-Julia/GraknClient.jl/blob/main/LICENSE 

# 
# package grakn.client.concept.answer;
# 
# import grakn.client.api.answer.ConceptMap;
# import grakn.client.api.concept.Concept;
# import grakn.client.common.exception.GraknClientException;
# import grakn.client.concept.thing.ThingImpl;
# import grakn.client.concept.type.TypeImpl;
# import grakn.protocol.AnswerProto;
# 
# import java.util.Collection;
# import java.util.Collections;
# import java.util.HashMap;
# import java.util.Map;
# import java.util.stream.Collectors;
# 
# import static grakn.client.common.exception.ErrorMessage.Query.VARIABLE_DOES_NOT_EXIST;
# 
# public class ConceptMapImpl implements ConceptMap {
# 
#     private final Map<String, Concept> map;
# 
#     public ConceptMapImpl(Map<String, Concept> map) {
#         this.map = Collections.unmodifiableMap(map);
#     }
# 
#     public static ConceptMap of(AnswerProto.ConceptMap res) {
#         Map<String, Concept> variableMap = new HashMap<>();
#         res.getMapMap().forEach((resVar, resConcept) -> {
#             Concept concept;
#             if (resConcept.hasThing()) concept = ThingImpl.of(resConcept.getThing());
#             else concept = TypeImpl.of(resConcept.getType());
#             variableMap.put(resVar, concept);
#         });
#         return new ConceptMapImpl(Collections.unmodifiableMap(variableMap));
#     }
# 
#     @Override
#     public Map<String, Concept> map() {
#         return map;
#     }
# 
#     @Override
#     public Collection<Concept> concepts() {
#         return map.values();
#     }
# 
#     @Override
#     public Concept get(String variable) {
#         Concept concept = map.get(variable);
#         if (concept == null) throw new GraknClientException(VARIABLE_DOES_NOT_EXIST, variable);
#         return concept;
#     }
# 
#     @Override
#     public String toString() {
#         return map.entrySet().stream()
#                 .sorted(Map.Entry.comparingByKey())
#                 .map(e -> "[" + e.getKey() + "/" + e.getValue() + "]").collect(Collectors.joining());
#     }
# 
#     @Override
#     public boolean equals(Object obj) {
#         if (obj == this) return true;
#         if (obj == null || getClass() != obj.getClass()) return false;
#         ConceptMapImpl a2 = (ConceptMapImpl) obj;
#         return map.equals(a2.map);
#     }
# 
#     @Override
#     public int hashCode() { return map.hashCode();}
# }
