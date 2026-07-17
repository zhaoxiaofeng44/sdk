#include "dart2cpp_lowered.h"

struct LoggerMixin;
struct FormatterMixin;
struct DiamondClassValue;
struct StatefulMixinMixin;
struct StatefulWidgetValue;
struct LayerAMixin;
struct LayerBMixin;
struct LayerCMixin;
struct DeepMixinClassValue;
template<typename T> struct MappableMixin;
template<typename T> struct FilterableMixin;
template<typename T> struct BoxValue;
struct IdentifiableValue;
struct DescribableValue;
struct TaggableMixin;
struct ResourceValue;
struct TaggedResourceValue;
struct BaseProcessorValue;
struct UpperProcessorValue;
struct PrefixProcessorValue;
struct AddableMixin;
struct AmountValue;
struct Printable2Mixin;
struct VehicleValue;
struct CarValue;
struct ElectricCarValue;
struct MeasurableValue;
struct ScalableMixin;
struct SegmentValue;
struct WeightedSegmentValue;
struct NamedMixinMixin;
struct DescribedMixinMixin;
struct MultiMixinEntityValue;
struct EncoderValue;
struct Base64MixinMixin;
struct HexMixinMixin;
struct MultiEncoderValue;
struct CustomEncoderValue;
template<typename T> struct ContainerValue;
template<typename T> struct LabeledContainerValue;
template<typename T> struct PriorityContainerValue;
struct ChainMixinMixin;
struct ChainClassValue;
struct ChainSubClassValue;
struct Expression2Value;
struct NumberExprValue;
struct BinaryExprValue;
struct HealthMixinMixin;
struct ManaMixinMixin;
struct StaminaMixinMixin;
struct GameCharacterValue;
struct WarriorValue;
struct MageValue;
std::string Logger_prefix(LoggerMixin* this__);
std::string Logger_format(LoggerMixin* this__, std::string msg);
std::string Formatter_prefix(FormatterMixin* this__);
std::string Formatter_format(FormatterMixin* this__, std::string msg);
int64_t StatefulMixin_counter(StatefulMixinMixin* this__);
void StatefulMixin_counter(StatefulMixinMixin* this__, int64_t value);
void StatefulMixin_increment(StatefulMixinMixin* this__);
void StatefulMixin_decrement(StatefulMixinMixin* this__);
std::string StatefulMixin_counterStatus(StatefulMixinMixin* this__);
std::string LayerA_layer(LayerAMixin* this__);
std::string LayerA_onlyA(LayerAMixin* this__);
std::string LayerB_layer(LayerBMixin* this__);
std::string LayerB_onlyB(LayerBMixin* this__);
std::string LayerC_layer(LayerCMixin* this__);
std::string LayerC_onlyC(LayerCMixin* this__);
template<typename T> T Mappable_value(MappableMixin<T>* this__);
template<typename T, typename R> R Mappable_mapValue(MappableMixin<T>* this__, TypeFunction1<R, T>* transform);
template<typename T> std::string Mappable_describe(MappableMixin<T>* this__);
template<typename T> T Filterable_value(FilterableMixin<T>* this__);
template<typename T> bool Filterable_test(FilterableMixin<T>* this__, TypeFunction1<bool, T>* predicate);
void Taggable_tag(TaggableMixin* this__, std::string t);
StaticList<std::string>* Taggable_allTags(TaggableMixin* this__);
bool Taggable_hasTag(TaggableMixin* this__, std::string t);
int64_t Addable_numericValue(AddableMixin* this__);
int64_t Addable_addValues(AddableMixin* this__, int64_t other);
int64_t Addable_doubleValue(AddableMixin* this__);
std::string Printable2_toPrettyString(Printable2Mixin* this__);
void Printable2_prettyPrint(Printable2Mixin* this__);
double Scalable_scale(ScalableMixin* this__, double factor);
std::string Scalable_measureInfo(ScalableMixin* this__);
std::string NamedMixin_label(NamedMixinMixin* this__);
std::string NamedMixin_greet(NamedMixinMixin* this__);
std::string DescribedMixin_label(DescribedMixinMixin* this__);
std::string DescribedMixin_info(DescribedMixinMixin* this__);
std::string Base64Mixin_encode(Base64MixinMixin* this__, std::string input);
std::string HexMixin_encode(HexMixinMixin* this__, std::string input);
std::string ChainMixin_step1(ChainMixinMixin* this__);
std::string ChainMixin_step2(ChainMixinMixin* this__);
std::string ChainMixin_step3(ChainMixinMixin* this__);
std::string ChainMixin_fullChain(ChainMixinMixin* this__);
int64_t HealthMixin_maxHealth(HealthMixinMixin* this__);
int64_t HealthMixin_health(HealthMixinMixin* this__);
std::string HealthMixin_healthBar(HealthMixinMixin* this__);
int64_t ManaMixin_maxMana(ManaMixinMixin* this__);
int64_t ManaMixin_mana(ManaMixinMixin* this__);
std::string ManaMixin_manaBar(ManaMixinMixin* this__);
int64_t StaminaMixin_maxStamina(StaminaMixinMixin* this__);
int64_t StaminaMixin_stamina(StaminaMixinMixin* this__);
std::string StaminaMixin_staminaBar(StaminaMixinMixin* this__);
DiamondClassValue* DiamondClass_new(DiamondClassValue* this__, std::string name);
std::string DiamondClass_display(DiamondClassValue* this__, std::string msg);
StatefulWidgetValue* StatefulWidget_new(StatefulWidgetValue* this__, std::string id);
std::string StatefulWidget_toString(StatefulWidgetValue* this__);
DeepMixinClassValue* DeepMixinClass_new(DeepMixinClassValue* this__);
std::string DeepMixinClass_allLayers(DeepMixinClassValue* this__);
template<typename T> BoxValue<T>* Box_new(BoxValue<T>* this__, T value);
template<typename T> std::string Box_toString(BoxValue<T>* this__);
IdentifiableValue* Identifiable_new(IdentifiableValue* this__);
std::string Identifiable_get_id(IdentifiableValue* this__);
DescribableValue* Describable_new(DescribableValue* this__);
std::string Describable_describe(DescribableValue* this__);
ResourceValue* Resource_new(ResourceValue* this__, std::string id, std::string type);
std::string Resource_describe(ResourceValue* this__);
TaggedResourceValue* TaggedResource_new(TaggedResourceValue* this__, std::string id, std::string type);
std::string TaggedResource_describe(TaggedResourceValue* this__);
BaseProcessorValue* BaseProcessor_new(BaseProcessorValue* this__);
std::string BaseProcessor_process(BaseProcessorValue* this__, std::string input);
std::string BaseProcessor_get_processorName(BaseProcessorValue* this__);
UpperProcessorValue* UpperProcessor_new(UpperProcessorValue* this__);
std::string UpperProcessor_process(UpperProcessorValue* this__, std::string input);
std::string UpperProcessor_get_processorName(UpperProcessorValue* this__);
PrefixProcessorValue* PrefixProcessor_new(PrefixProcessorValue* this__, std::string prefix);
std::string PrefixProcessor_process(PrefixProcessorValue* this__, std::string input);
std::string PrefixProcessor_get_processorName(PrefixProcessorValue* this__);
AmountValue* Amount_new(AmountValue* this__, int64_t numericValue);
AmountValue* Amount_add(AmountValue* this__, AmountValue* other);
AmountValue* Amount_sub(AmountValue* this__, AmountValue* other);
bool Amount_lt(AmountValue* this__, AmountValue* other);
bool Amount_gt(AmountValue* this__, AmountValue* other);
std::string Amount_toString(AmountValue* this__);
VehicleValue* Vehicle_new(VehicleValue* this__, std::string make, int64_t year);
std::string Vehicle_toString(VehicleValue* this__);
CarValue* Car_new(CarValue* this__, std::string make, int64_t year, int64_t doors);
std::string Car_toPrettyString(CarValue* this__);
std::string Car_toString(CarValue* this__);
ElectricCarValue* ElectricCar_new(ElectricCarValue* this__, std::string make, int64_t year, int64_t doors, int64_t range);
std::string ElectricCar_toPrettyString(ElectricCarValue* this__);
std::string ElectricCar_toString(ElectricCarValue* this__);
MeasurableValue* Measurable_new(MeasurableValue* this__);
double Measurable_measure(MeasurableValue* this__);
SegmentValue* Segment_new(SegmentValue* this__, double length);
double Segment_measure(SegmentValue* this__);
std::string Segment_toString(SegmentValue* this__);
WeightedSegmentValue* WeightedSegment_new(WeightedSegmentValue* this__, double length, double weight);
double WeightedSegment_measure(WeightedSegmentValue* this__);
std::string WeightedSegment_toString(WeightedSegmentValue* this__);
MultiMixinEntityValue* MultiMixinEntity_new(MultiMixinEntityValue* this__);
std::string MultiMixinEntity_get_label(MultiMixinEntityValue* this__);
std::string MultiMixinEntity_fullInfo(MultiMixinEntityValue* this__);
EncoderValue* Encoder_new(EncoderValue* this__);
std::string Encoder_encode(EncoderValue* this__, std::string input);
MultiEncoderValue* MultiEncoder_new(MultiEncoderValue* this__);
std::string MultiEncoder_encodeAll(MultiEncoderValue* this__, std::string input);
CustomEncoderValue* CustomEncoder_new(CustomEncoderValue* this__);
std::string CustomEncoder_encode(CustomEncoderValue* this__, std::string input);
template<typename T> ContainerValue<T>* Container_new(ContainerValue<T>* this__, T item);
template<typename T> std::string Container_describe(ContainerValue<T>* this__);
template<typename T> T Container_get_content(ContainerValue<T>* this__);
template<typename T> LabeledContainerValue<T>* LabeledContainer_new(LabeledContainerValue<T>* this__, T item, std::string label);
template<typename T> std::string LabeledContainer_describe(LabeledContainerValue<T>* this__);
template<typename T> PriorityContainerValue<T>* PriorityContainer_new(PriorityContainerValue<T>* this__, T item, std::string label, int64_t priority);
template<typename T> std::string PriorityContainer_describe(PriorityContainerValue<T>* this__);
ChainClassValue* ChainClass_new(ChainClassValue* this__);
std::string ChainClass_step1(ChainClassValue* this__);
ChainSubClassValue* ChainSubClass_new(ChainSubClassValue* this__);
std::string ChainSubClass_step2(ChainSubClassValue* this__);
Expression2Value* Expression2_new(Expression2Value* this__);
double Expression2_evaluate(Expression2Value* this__);
std::string Expression2_display(Expression2Value* this__);
NumberExprValue* NumberExpr_new(NumberExprValue* this__, double value);
double NumberExpr_evaluate(NumberExprValue* this__);
std::string NumberExpr_display(NumberExprValue* this__);
BinaryExprValue* BinaryExpr_new(BinaryExprValue* this__, Expression2Value* left, Expression2Value* right, std::string op, TypeFunction2<double, double, double>* _compute);
BinaryExprValue* BinaryExpr_new_add(Expression2Value* l, Expression2Value* r);
BinaryExprValue* BinaryExpr_new_mul(Expression2Value* l, Expression2Value* r);
double BinaryExpr_evaluate(BinaryExprValue* this__);
std::string BinaryExpr_display(BinaryExprValue* this__);
GameCharacterValue* GameCharacter_new(GameCharacterValue* this__, std::string name);
std::string GameCharacter_statusBars(GameCharacterValue* this__);
WarriorValue* Warrior_new(WarriorValue* this__, std::string name);
int64_t Warrior_get_maxHealth(WarriorValue* this__);
int64_t Warrior_get_maxStamina(WarriorValue* this__);
MageValue* Mage_new(MageValue* this__, std::string name);
int64_t Mage_get_maxMana(MageValue* this__);
int64_t Mage_get_maxHealth(MageValue* this__);
int main();
AnyGC* DiamondClass_Object_Logger_Formatter_get_prefix(DiamondClassValue* this__);
AnyGC* DiamondClass_Object_Logger_Formatter_format(DiamondClassValue* this__, std::string msg);
AnyGC* StatefulWidget_Object_StatefulMixin_get_counter(StatefulWidgetValue* this__);
void StatefulWidget_Object_StatefulMixin_increment(StatefulWidgetValue* this__);
void StatefulWidget_Object_StatefulMixin_decrement(StatefulWidgetValue* this__);
AnyGC* StatefulWidget_Object_StatefulMixin_get_counterStatus(StatefulWidgetValue* this__);
void StatefulWidget_Object_StatefulMixin_set_counter(StatefulWidgetValue* this__, AnyGC* value);
AnyGC* DeepMixinClass_Object_LayerA_LayerB_LayerC_layer(DeepMixinClassValue* this__);
AnyGC* DeepMixinClass_Object_LayerA_onlyA(DeepMixinClassValue* this__);
AnyGC* DeepMixinClass_Object_LayerA_LayerB_onlyB(DeepMixinClassValue* this__);
AnyGC* DeepMixinClass_Object_LayerA_LayerB_LayerC_onlyC(DeepMixinClassValue* this__);
template<typename T> T Box_Object_Mappable_Filterable_get_value(BoxValue<T>* this__);
template<typename T, typename R> AnyGC* Box_Object_Mappable_mapValue(BoxValue<T>* this__, TypeFunction1<R, T>* transform);
template<typename T> AnyGC* Box_Object_Mappable_describe(BoxValue<T>* this__);
template<typename T> AnyGC* Box_Object_Mappable_Filterable_test(BoxValue<T>* this__, TypeFunction1<bool, T>* predicate);
void TaggedResource_Resource_Taggable_tag(TaggedResourceValue* this__, std::string t);
AnyGC* TaggedResource_Resource_Taggable_get_allTags(TaggedResourceValue* this__);
AnyGC* TaggedResource_Resource_Taggable_hasTag(TaggedResourceValue* this__, std::string t);
int64_t Amount_Object_Addable_get_numericValue(AmountValue* this__);
AnyGC* Amount_Object_Addable_addValues(AmountValue* this__, int64_t other);
AnyGC* Amount_Object_Addable_doubleValue(AmountValue* this__);
void Car_Vehicle_Printable2_prettyPrint(CarValue* this__);
AnyGC* Segment_Measurable_Scalable_scale(SegmentValue* this__, double factor);
AnyGC* Segment_Measurable_Scalable_measureInfo(SegmentValue* this__);
AnyGC* MultiMixinEntity_Object_NamedMixin_greet(MultiMixinEntityValue* this__);
AnyGC* MultiMixinEntity_Object_NamedMixin_DescribedMixin_info(MultiMixinEntityValue* this__);
AnyGC* MultiEncoder_Object_Base64Mixin_HexMixin_encode(MultiEncoderValue* this__, std::string input);
AnyGC* ChainClass_Object_ChainMixin_step2(ChainClassValue* this__);
AnyGC* ChainClass_Object_ChainMixin_step3(ChainClassValue* this__);
AnyGC* ChainClass_Object_ChainMixin_fullChain(ChainClassValue* this__);
AnyGC* GameCharacter_Object_HealthMixin_get_maxHealth(GameCharacterValue* this__);
AnyGC* GameCharacter_Object_HealthMixin_get_health(GameCharacterValue* this__);
AnyGC* GameCharacter_Object_HealthMixin_healthBar(GameCharacterValue* this__);
AnyGC* GameCharacter_Object_HealthMixin_ManaMixin_get_maxMana(GameCharacterValue* this__);
AnyGC* GameCharacter_Object_HealthMixin_ManaMixin_get_mana(GameCharacterValue* this__);
AnyGC* GameCharacter_Object_HealthMixin_ManaMixin_manaBar(GameCharacterValue* this__);
AnyGC* GameCharacter_Object_HealthMixin_ManaMixin_StaminaMixin_get_maxStamina(GameCharacterValue* this__);
AnyGC* GameCharacter_Object_HealthMixin_ManaMixin_StaminaMixin_get_stamina(GameCharacterValue* this__);
AnyGC* GameCharacter_Object_HealthMixin_ManaMixin_StaminaMixin_staminaBar(GameCharacterValue* this__);
AnyGC* DiamondClass_get_prefix(DiamondClassValue* this__);
AnyGC* DiamondClass_format(DiamondClassValue* this__, std::string msg);
AnyGC* StatefulWidget_get_counter(StatefulWidgetValue* this__);
void StatefulWidget_increment(StatefulWidgetValue* this__);
void StatefulWidget_decrement(StatefulWidgetValue* this__);
AnyGC* StatefulWidget_get_counterStatus(StatefulWidgetValue* this__);
void StatefulWidget_set_counter(StatefulWidgetValue* this__, AnyGC* value);
AnyGC* DeepMixinClass_layer(DeepMixinClassValue* this__);
AnyGC* DeepMixinClass_onlyA(DeepMixinClassValue* this__);
AnyGC* DeepMixinClass_onlyB(DeepMixinClassValue* this__);
AnyGC* DeepMixinClass_onlyC(DeepMixinClassValue* this__);
template<typename T> T Box_get_value(BoxValue<T>* this__);
template<typename T, typename R> AnyGC* Box_mapValue(BoxValue<T>* this__, TypeFunction1<R, T>* transform);
template<typename T> AnyGC* Box_describe(BoxValue<T>* this__);
template<typename T> AnyGC* Box_test(BoxValue<T>* this__, TypeFunction1<bool, T>* predicate);
std::string Resource_get_id(ResourceValue* this__);
AnyGC* TaggedResource_get_id(TaggedResourceValue* this__);
void TaggedResource_tag(TaggedResourceValue* this__, std::string t);
AnyGC* TaggedResource_get_allTags(TaggedResourceValue* this__);
AnyGC* TaggedResource_hasTag(TaggedResourceValue* this__, std::string t);
int64_t Amount_get_numericValue(AmountValue* this__);
AnyGC* Amount_addValues(AmountValue* this__, int64_t other);
AnyGC* Amount_doubleValue(AmountValue* this__);
void Car_prettyPrint(CarValue* this__);
void ElectricCar_prettyPrint(ElectricCarValue* this__);
AnyGC* Segment_scale(SegmentValue* this__, double factor);
AnyGC* Segment_measureInfo(SegmentValue* this__);
AnyGC* WeightedSegment_scale(WeightedSegmentValue* this__, double factor);
AnyGC* WeightedSegment_measureInfo(WeightedSegmentValue* this__);
AnyGC* MultiMixinEntity_greet(MultiMixinEntityValue* this__);
AnyGC* MultiMixinEntity_info(MultiMixinEntityValue* this__);
AnyGC* MultiEncoder_encode(MultiEncoderValue* this__, std::string input);
AnyGC* CustomEncoder_encodeAll(CustomEncoderValue* this__, std::string input);
template<typename T> AnyGC* LabeledContainer_get_content(LabeledContainerValue<T>* this__);
template<typename T> AnyGC* PriorityContainer_get_content(PriorityContainerValue<T>* this__);
AnyGC* ChainClass_step2(ChainClassValue* this__);
AnyGC* ChainClass_step3(ChainClassValue* this__);
AnyGC* ChainClass_fullChain(ChainClassValue* this__);
AnyGC* ChainSubClass_step1(ChainSubClassValue* this__);
AnyGC* ChainSubClass_step3(ChainSubClassValue* this__);
AnyGC* ChainSubClass_fullChain(ChainSubClassValue* this__);
AnyGC* GameCharacter_get_maxHealth(GameCharacterValue* this__);
AnyGC* GameCharacter_get_health(GameCharacterValue* this__);
AnyGC* GameCharacter_healthBar(GameCharacterValue* this__);
AnyGC* GameCharacter_get_maxMana(GameCharacterValue* this__);
AnyGC* GameCharacter_get_mana(GameCharacterValue* this__);
AnyGC* GameCharacter_manaBar(GameCharacterValue* this__);
AnyGC* GameCharacter_get_maxStamina(GameCharacterValue* this__);
AnyGC* GameCharacter_get_stamina(GameCharacterValue* this__);
AnyGC* GameCharacter_staminaBar(GameCharacterValue* this__);
AnyGC* Warrior_get_health(WarriorValue* this__);
AnyGC* Warrior_healthBar(WarriorValue* this__);
AnyGC* Warrior_get_maxMana(WarriorValue* this__);
AnyGC* Warrior_get_mana(WarriorValue* this__);
AnyGC* Warrior_manaBar(WarriorValue* this__);
AnyGC* Warrior_get_stamina(WarriorValue* this__);
AnyGC* Warrior_staminaBar(WarriorValue* this__);
AnyGC* Warrior_statusBars(WarriorValue* this__);
AnyGC* Mage_get_health(MageValue* this__);
AnyGC* Mage_healthBar(MageValue* this__);
AnyGC* Mage_get_mana(MageValue* this__);
AnyGC* Mage_manaBar(MageValue* this__);
AnyGC* Mage_get_maxStamina(MageValue* this__);
AnyGC* Mage_get_stamina(MageValue* this__);
AnyGC* Mage_staminaBar(MageValue* this__);
AnyGC* Mage_statusBars(MageValue* this__);

struct LoggerMixin : AnyGC {
    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }
};
std::unordered_map<std::string, void*> LoggerMixin::_vptrMap;


struct FormatterMixin : AnyGC {
    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }
};
std::unordered_map<std::string, void*> FormatterMixin::_vptrMap;


struct StatefulMixinMixin : AnyGC {
    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }
    int64_t _counter{0};
};
std::unordered_map<std::string, void*> StatefulMixinMixin::_vptrMap;


struct LayerAMixin : AnyGC {
    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }
};
std::unordered_map<std::string, void*> LayerAMixin::_vptrMap;


struct LayerBMixin : AnyGC {
    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }
};
std::unordered_map<std::string, void*> LayerBMixin::_vptrMap;


struct LayerCMixin : AnyGC {
    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }
};
std::unordered_map<std::string, void*> LayerCMixin::_vptrMap;


template<typename T>
struct MappableMixin : AnyGC {
    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }
};
template<typename T> std::unordered_map<std::string, void*> MappableMixin<T>::_vptrMap;


template<typename T>
struct FilterableMixin : AnyGC {
    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }
};
template<typename T> std::unordered_map<std::string, void*> FilterableMixin<T>::_vptrMap;


struct TaggableMixin : AnyGC {
    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }
    StaticList<std::string>* _tags{nullptr};
};
std::unordered_map<std::string, void*> TaggableMixin::_vptrMap;


struct AddableMixin : AnyGC {
    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }
};
std::unordered_map<std::string, void*> AddableMixin::_vptrMap;


struct Printable2Mixin : AnyGC {
    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }
};
std::unordered_map<std::string, void*> Printable2Mixin::_vptrMap;


struct ScalableMixin : AnyGC {
    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }
};
std::unordered_map<std::string, void*> ScalableMixin::_vptrMap;


struct NamedMixinMixin : AnyGC {
    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }
};
std::unordered_map<std::string, void*> NamedMixinMixin::_vptrMap;


struct DescribedMixinMixin : AnyGC {
    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }
};
std::unordered_map<std::string, void*> DescribedMixinMixin::_vptrMap;


struct Base64MixinMixin : AnyGC {
    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }
};
std::unordered_map<std::string, void*> Base64MixinMixin::_vptrMap;


struct HexMixinMixin : AnyGC {
    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }
};
std::unordered_map<std::string, void*> HexMixinMixin::_vptrMap;


struct ChainMixinMixin : AnyGC {
    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }
};
std::unordered_map<std::string, void*> ChainMixinMixin::_vptrMap;


struct HealthMixinMixin : AnyGC {
    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }
};
std::unordered_map<std::string, void*> HealthMixinMixin::_vptrMap;


struct ManaMixinMixin : AnyGC {
    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }
};
std::unordered_map<std::string, void*> ManaMixinMixin::_vptrMap;


struct StaminaMixinMixin : AnyGC {
    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }
};
std::unordered_map<std::string, void*> StaminaMixinMixin::_vptrMap;


struct DiamondClassValue : VPtr {
    std::string name{""};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> DiamondClassValue::_vptrMap;

struct StatefulWidgetValue : VPtr {
    std::string id{""};
    int64_t _counter{0};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> StatefulWidgetValue::_vptrMap;

struct DeepMixinClassValue : VPtr {

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> DeepMixinClassValue::_vptrMap;

template<typename T>
struct BoxValue : VPtr {
    T value{};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

template<typename T> std::unordered_map<std::string, void*> BoxValue<T>::_vptrMap;

struct IdentifiableValue : VPtr {

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> IdentifiableValue::_vptrMap;

struct DescribableValue : VPtr {

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> DescribableValue::_vptrMap;

struct ResourceValue : IdentifiableValue {
    std::string id{""};
    std::string type{""};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        IdentifiableValue::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> ResourceValue::_vptrMap;

struct TaggedResourceValue : ResourceValue {
    StaticList<std::string>* _tags{nullptr};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        ResourceValue::gcMark(flag);
        if (_tags) _tags->gcMark(flag);
    }
};

std::unordered_map<std::string, void*> TaggedResourceValue::_vptrMap;

struct BaseProcessorValue : VPtr {

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> BaseProcessorValue::_vptrMap;

struct UpperProcessorValue : BaseProcessorValue {

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        BaseProcessorValue::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> UpperProcessorValue::_vptrMap;

struct PrefixProcessorValue : UpperProcessorValue {
    std::string prefix{""};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        UpperProcessorValue::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> PrefixProcessorValue::_vptrMap;

struct AmountValue : VPtr {
    int64_t numericValue{0};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> AmountValue::_vptrMap;

struct VehicleValue : VPtr {
    std::string make{""};
    int64_t year{0};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> VehicleValue::_vptrMap;

struct CarValue : VehicleValue {
    int64_t doors{0};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VehicleValue::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> CarValue::_vptrMap;

struct ElectricCarValue : CarValue {
    int64_t range{0};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        CarValue::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> ElectricCarValue::_vptrMap;

struct MeasurableValue : VPtr {

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> MeasurableValue::_vptrMap;

struct SegmentValue : MeasurableValue {
    double length{0.0};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        MeasurableValue::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> SegmentValue::_vptrMap;

struct WeightedSegmentValue : SegmentValue {
    double weight{0.0};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        SegmentValue::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> WeightedSegmentValue::_vptrMap;

struct MultiMixinEntityValue : VPtr {

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> MultiMixinEntityValue::_vptrMap;

struct EncoderValue : VPtr {

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> EncoderValue::_vptrMap;

struct MultiEncoderValue : VPtr {

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> MultiEncoderValue::_vptrMap;

struct CustomEncoderValue : MultiEncoderValue {

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        MultiEncoderValue::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> CustomEncoderValue::_vptrMap;

template<typename T>
struct ContainerValue : VPtr {
    T item{};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

template<typename T> std::unordered_map<std::string, void*> ContainerValue<T>::_vptrMap;

template<typename T>
struct LabeledContainerValue : ContainerValue<T> {
    std::string label{""};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        ContainerValue<T>::gcMark(flag);
    }
};

template<typename T> std::unordered_map<std::string, void*> LabeledContainerValue<T>::_vptrMap;

template<typename T>
struct PriorityContainerValue : LabeledContainerValue<T> {
    int64_t priority{0};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        LabeledContainerValue<T>::gcMark(flag);
    }
};

template<typename T> std::unordered_map<std::string, void*> PriorityContainerValue<T>::_vptrMap;

struct ChainClassValue : VPtr {

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> ChainClassValue::_vptrMap;

struct ChainSubClassValue : ChainClassValue {

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        ChainClassValue::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> ChainSubClassValue::_vptrMap;

struct Expression2Value : VPtr {

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> Expression2Value::_vptrMap;

struct NumberExprValue : Expression2Value {
    double value{0.0};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        Expression2Value::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> NumberExprValue::_vptrMap;

struct BinaryExprValue : Expression2Value {
    Expression2Value* left{nullptr};
    Expression2Value* right{nullptr};
    std::string op{""};
    TypeFunction2<double, double, double>* _compute{nullptr};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        Expression2Value::gcMark(flag);
        if (left) left->gcMark(flag);
        if (right) right->gcMark(flag);
        if (_compute) _compute->gcMark(flag);
    }
};

std::unordered_map<std::string, void*> BinaryExprValue::_vptrMap;

struct ClosureEnv_0 : TypeFunction2<double, double, double> {
    ClosureEnv_0() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0, AnyGC* _p1) {
        auto* _self = static_cast<ClosureEnv_0*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(dynAs<double>(_p0), dynAs<double>(_p1)));
    }
    double call(double a, double b) {
    return (a + b);
    }
};

struct ClosureEnv_1 : TypeFunction2<double, double, double> {
    ClosureEnv_1() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0, AnyGC* _p1) {
        auto* _self = static_cast<ClosureEnv_1*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(dynAs<double>(_p0), dynAs<double>(_p1)));
    }
    double call(double a, double b) {
    return (a * b);
    }
};

struct GameCharacterValue : VPtr {
    std::string name{""};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> GameCharacterValue::_vptrMap;

struct WarriorValue : GameCharacterValue {

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        GameCharacterValue::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> WarriorValue::_vptrMap;

struct MageValue : GameCharacterValue {

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        GameCharacterValue::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> MageValue::_vptrMap;

struct ClosureEnv_2 : TypeFunction1<int64_t, int64_t> {
    ClosureEnv_2() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_2*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(dynAs<int64_t>(_p0)));
    }
    int64_t call(int64_t v) {
    return (v * 2LL);
    }
};

struct ClosureEnv_3 : TypeFunction1<bool, int64_t> {
    ClosureEnv_3() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_3*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(dynAs<int64_t>(_p0)));
    }
    bool call(int64_t v) {
    return (v > 10LL);
    }
};

struct ClosureEnv_4 : TypeFunction1<bool, int64_t> {
    ClosureEnv_4() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_4*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(dynAs<int64_t>(_p0)));
    }
    bool call(int64_t v) {
    return (v > 100LL);
    }
};

struct ClosureEnv_5 : TypeFunction1<std::string, std::string> {
    ClosureEnv_5() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_5*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(dynAs<std::string>(_p0)));
    }
    std::string call(std::string s) {
    return dart_str_toUpper(s);
    }
};


std::string Logger_prefix(LoggerMixin* this__) {
    auto this_ = this__;
    return std::string("LOG");
}

std::string Logger_format(LoggerMixin* this__, std::string msg) {
    auto this_ = this__;
    return dart_str(std::string("[")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_prefix"]))(this_))) + dart_str(std::string("] ")) + dart_str(msg);
}

std::string Formatter_prefix(FormatterMixin* this__) {
    auto this_ = this__;
    return std::string("FMT");
}

std::string Formatter_format(FormatterMixin* this__, std::string msg) {
    auto this_ = this__;
    return dart_str(std::string("{")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_prefix"]))(this_))) + dart_str(std::string(": ")) + dart_str(msg) + dart_str(std::string("}"));
}

int64_t StatefulMixin_counter(StatefulMixinMixin* this__) {
    auto this_ = this__;
    return this_->_counter;
}

void StatefulMixin_counter(StatefulMixinMixin* this__, int64_t value) {
    auto this_ = this__;
    (this_->_counter = value);
    return;
}

void StatefulMixin_increment(StatefulMixinMixin* this__) {
    auto this_ = this__;
    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["set_counter"]))(this_, _box((dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_counter"]))(this_)) + 1LL)));
    return;
}

void StatefulMixin_decrement(StatefulMixinMixin* this__) {
    auto this_ = this__;
    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["set_counter"]))(this_, _box((dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_counter"]))(this_)) - 1LL)));
    return;
}

std::string StatefulMixin_counterStatus(StatefulMixinMixin* this__) {
    auto this_ = this__;
    return dart_str(std::string("count=")) + dart_str(dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_counter"]))(this_)));
}

std::string LayerA_layer(LayerAMixin* this__) {
    auto this_ = this__;
    return std::string("A");
}

std::string LayerA_onlyA(LayerAMixin* this__) {
    auto this_ = this__;
    return std::string("onlyA");
}

std::string LayerB_layer(LayerBMixin* this__) {
    auto this_ = this__;
    return std::string("B");
}

std::string LayerB_onlyB(LayerBMixin* this__) {
    auto this_ = this__;
    return std::string("onlyB");
}

std::string LayerC_layer(LayerCMixin* this__) {
    auto this_ = this__;
    return std::string("C");
}

std::string LayerC_onlyC(LayerCMixin* this__) {
    auto this_ = this__;
    return std::string("onlyC");
}

template<typename T>
T Mappable_value(MappableMixin<T>* this__) {
    auto this_ = this__;
    return T{};
}

template<typename T, typename R>
R Mappable_mapValue(MappableMixin<T>* this__, TypeFunction1<R, T>* transform) {
    auto this_ = this__;
    return transform->call((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_value"]))(this_));
}

template<typename T>
std::string Mappable_describe(MappableMixin<T>* this__) {
    auto this_ = this__;
    return dart_str(std::string("Mappable<")) + dart_str(std::string("TypeParameterType(Mappable.T%)")) + dart_str(std::string(">(")) + dart_str((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_value"]))(this_)) + dart_str(std::string(")"));
}

template<typename T>
T Filterable_value(FilterableMixin<T>* this__) {
    auto this_ = this__;
    return T{};
}

template<typename T>
bool Filterable_test(FilterableMixin<T>* this__, TypeFunction1<bool, T>* predicate) {
    auto this_ = this__;
    return predicate->call((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_value"]))(this_));
}

void Taggable_tag(TaggableMixin* this__, std::string t) {
    auto this_ = this__;
    this_->_tags->add(t);
    return;
}

StaticList<std::string>* Taggable_allTags(TaggableMixin* this__) {
    auto this_ = this__;
    return unmodifiable<std::string>(this_->_tags);
}

bool Taggable_hasTag(TaggableMixin* this__, std::string t) {
    auto this_ = this__;
    return this_->_tags->contains(t);
}

int64_t Addable_numericValue(AddableMixin* this__) {
    auto this_ = this__;
    return 0;
}

int64_t Addable_addValues(AddableMixin* this__, int64_t other) {
    auto this_ = this__;
    return (dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_numericValue"]))(this_)) + other);
}

int64_t Addable_doubleValue(AddableMixin* this__) {
    auto this_ = this__;
    return dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["addValues"]))(this_, _box(dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_numericValue"]))(this_)))));
}

std::string Printable2_toPrettyString(Printable2Mixin* this__) {
    auto this_ = this__;
    throw DartUnimplementedError(dart_str(std::string("abstract method Printable2.toPrettyString")));
}

void Printable2_prettyPrint(Printable2Mixin* this__) {
    auto this_ = this__;
    staticPrint(dart_str(std::string(">> ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["toPrettyString"]))(this_))));
    return;
}

double Scalable_scale(ScalableMixin* this__, double factor) {
    auto this_ = this__;
    return (dynAs<double>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["measure"]))(this_)) * factor);
}

std::string Scalable_measureInfo(ScalableMixin* this__) {
    auto this_ = this__;
    return dart_str(std::string("measure=")) + dart_str(([&]() { std::ostringstream _ss; _ss << std::fixed << std::setprecision(1LL) << dynAs<double>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["measure"]))(this_)); return _ss.str(); })());
}

std::string NamedMixin_label(NamedMixinMixin* this__) {
    auto this_ = this__;
    return std::string("NamedMixin");
}

std::string NamedMixin_greet(NamedMixinMixin* this__) {
    auto this_ = this__;
    return dart_str(std::string("Hello from ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_label"]))(this_)));
}

std::string DescribedMixin_label(DescribedMixinMixin* this__) {
    auto this_ = this__;
    return std::string("DescribedMixin");
}

std::string DescribedMixin_info(DescribedMixinMixin* this__) {
    auto this_ = this__;
    return dart_str(std::string("Info: ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_label"]))(this_)));
}

std::string Base64Mixin_encode(Base64MixinMixin* this__, std::string input) {
    auto this_ = this__;
    return dart_str(std::string("base64(")) + dart_str(input) + dart_str(std::string(")"));
}

std::string HexMixin_encode(HexMixinMixin* this__, std::string input) {
    auto this_ = this__;
    return dart_str(std::string("hex(")) + dart_str(input) + dart_str(std::string(")"));
}

std::string ChainMixin_step1(ChainMixinMixin* this__) {
    auto this_ = this__;
    return std::string("S1");
}

std::string ChainMixin_step2(ChainMixinMixin* this__) {
    auto this_ = this__;
    return dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["step1"]))(this_))) + dart_str(std::string("->S2"));
}

std::string ChainMixin_step3(ChainMixinMixin* this__) {
    auto this_ = this__;
    return dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["step2"]))(this_))) + dart_str(std::string("->S3"));
}

std::string ChainMixin_fullChain(ChainMixinMixin* this__) {
    auto this_ = this__;
    return dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["step3"]))(this_))) + dart_str(std::string("->done"));
}

int64_t HealthMixin_maxHealth(HealthMixinMixin* this__) {
    auto this_ = this__;
    return 100LL;
}

int64_t HealthMixin_health(HealthMixinMixin* this__) {
    auto this_ = this__;
    return dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_maxHealth"]))(this_));
}

std::string HealthMixin_healthBar(HealthMixinMixin* this__) {
    auto this_ = this__;
    return dart_str(std::string("HP:")) + dart_str(dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_health"]))(this_))) + dart_str(std::string("/")) + dart_str(dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_maxHealth"]))(this_)));
}

int64_t ManaMixin_maxMana(ManaMixinMixin* this__) {
    auto this_ = this__;
    return 50LL;
}

int64_t ManaMixin_mana(ManaMixinMixin* this__) {
    auto this_ = this__;
    return dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_maxMana"]))(this_));
}

std::string ManaMixin_manaBar(ManaMixinMixin* this__) {
    auto this_ = this__;
    return dart_str(std::string("MP:")) + dart_str(dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_mana"]))(this_))) + dart_str(std::string("/")) + dart_str(dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_maxMana"]))(this_)));
}

int64_t StaminaMixin_maxStamina(StaminaMixinMixin* this__) {
    auto this_ = this__;
    return 80LL;
}

int64_t StaminaMixin_stamina(StaminaMixinMixin* this__) {
    auto this_ = this__;
    return dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_maxStamina"]))(this_));
}

std::string StaminaMixin_staminaBar(StaminaMixinMixin* this__) {
    auto this_ = this__;
    return dart_str(std::string("SP:")) + dart_str(dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_stamina"]))(this_))) + dart_str(std::string("/")) + dart_str(dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_maxStamina"]))(this_)));
}

AnyGC* _vptr_wrap_DiamondClass_get_prefix(AnyGC* obj__) {
    return _box(DiamondClass_get_prefix(static_cast<DiamondClassValue*>(obj__)));
}

AnyGC* _vptr_wrap_DiamondClass_format(AnyGC* obj__, AnyGC* arg0) {
    return _box(DiamondClass_format(static_cast<DiamondClassValue*>(obj__), dynAs<std::string>(arg0)));
}

AnyGC* _vptr_wrap_DiamondClass_display(AnyGC* obj__, AnyGC* arg0) {
    return _box(DiamondClass_display(static_cast<DiamondClassValue*>(obj__), dynAs<std::string>(arg0)));
}

static bool _DiamondClass_vptr_registered = []{ DiamondClassValue::_vptrMap["get_prefix"] = reinterpret_cast<void*>(&_vptr_wrap_DiamondClass_get_prefix); DiamondClassValue::_vptrMap["format"] = reinterpret_cast<void*>(&_vptr_wrap_DiamondClass_format); DiamondClassValue::_vptrMap["display"] = reinterpret_cast<void*>(&_vptr_wrap_DiamondClass_display); return true; }();
DiamondClassValue* DiamondClass_new(DiamondClassValue* this__, std::string name) {
    auto this_ = this__;
    if (DiamondClassValue::_vptrMap.empty()) {
        DiamondClassValue::_vptrMap["get_prefix"] = reinterpret_cast<void*>(&_vptr_wrap_DiamondClass_get_prefix);
        DiamondClassValue::_vptrMap["format"] = reinterpret_cast<void*>(&_vptr_wrap_DiamondClass_format);
        DiamondClassValue::_vptrMap["display"] = reinterpret_cast<void*>(&_vptr_wrap_DiamondClass_display);
    }
    this_->name = name;
    return this_;
}

std::string DiamondClass_display(DiamondClassValue* this__, std::string msg) {
    auto this_ = this__;
    return dart_str(this_->name) + dart_str(std::string(": ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["format"]))(this_, _box(msg))));
}

AnyGC* _vptr_wrap_StatefulWidget_get_counter(AnyGC* obj__) {
    return _box(StatefulWidget_get_counter(static_cast<StatefulWidgetValue*>(obj__)));
}

AnyGC* _vptr_wrap_StatefulWidget_increment(AnyGC* obj__) {
    StatefulWidget_increment(static_cast<StatefulWidgetValue*>(obj__));
    return nullptr;
}

AnyGC* _vptr_wrap_StatefulWidget_decrement(AnyGC* obj__) {
    StatefulWidget_decrement(static_cast<StatefulWidgetValue*>(obj__));
    return nullptr;
}

AnyGC* _vptr_wrap_StatefulWidget_get_counterStatus(AnyGC* obj__) {
    return _box(StatefulWidget_get_counterStatus(static_cast<StatefulWidgetValue*>(obj__)));
}

AnyGC* _vptr_wrap_StatefulWidget_set_counter(AnyGC* obj__, AnyGC* arg0) {
    StatefulWidget_set_counter(static_cast<StatefulWidgetValue*>(obj__), arg0);
    return nullptr;
}

AnyGC* _vptr_wrap_StatefulWidget_toString(AnyGC* obj__) {
    return _box(StatefulWidget_toString(static_cast<StatefulWidgetValue*>(obj__)));
}

static bool _StatefulWidget_vptr_registered = []{ StatefulWidgetValue::_vptrMap["get_counter"] = reinterpret_cast<void*>(&_vptr_wrap_StatefulWidget_get_counter); StatefulWidgetValue::_vptrMap["increment"] = reinterpret_cast<void*>(&_vptr_wrap_StatefulWidget_increment); StatefulWidgetValue::_vptrMap["decrement"] = reinterpret_cast<void*>(&_vptr_wrap_StatefulWidget_decrement); StatefulWidgetValue::_vptrMap["get_counterStatus"] = reinterpret_cast<void*>(&_vptr_wrap_StatefulWidget_get_counterStatus); StatefulWidgetValue::_vptrMap["set_counter"] = reinterpret_cast<void*>(&_vptr_wrap_StatefulWidget_set_counter); StatefulWidgetValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_StatefulWidget_toString); return true; }();
StatefulWidgetValue* StatefulWidget_new(StatefulWidgetValue* this__, std::string id) {
    auto this_ = this__;
    if (StatefulWidgetValue::_vptrMap.empty()) {
        StatefulWidgetValue::_vptrMap["get_counter"] = reinterpret_cast<void*>(&_vptr_wrap_StatefulWidget_get_counter);
        StatefulWidgetValue::_vptrMap["increment"] = reinterpret_cast<void*>(&_vptr_wrap_StatefulWidget_increment);
        StatefulWidgetValue::_vptrMap["decrement"] = reinterpret_cast<void*>(&_vptr_wrap_StatefulWidget_decrement);
        StatefulWidgetValue::_vptrMap["get_counterStatus"] = reinterpret_cast<void*>(&_vptr_wrap_StatefulWidget_get_counterStatus);
        StatefulWidgetValue::_vptrMap["set_counter"] = reinterpret_cast<void*>(&_vptr_wrap_StatefulWidget_set_counter);
        StatefulWidgetValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_StatefulWidget_toString);
    }
    this_->id = id;
    this_->_counter = 0LL;
    return this_;
}

std::string StatefulWidget_toString(StatefulWidgetValue* this__) {
    auto this_ = this__;
    return dart_str(std::string("Widget(")) + dart_str(this_->id) + dart_str(std::string(", ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_counterStatus"]))(this_))) + dart_str(std::string(")"));
}

AnyGC* _vptr_wrap_DeepMixinClass_layer(AnyGC* obj__) {
    return _box(DeepMixinClass_layer(static_cast<DeepMixinClassValue*>(obj__)));
}

AnyGC* _vptr_wrap_DeepMixinClass_onlyA(AnyGC* obj__) {
    return _box(DeepMixinClass_onlyA(static_cast<DeepMixinClassValue*>(obj__)));
}

AnyGC* _vptr_wrap_DeepMixinClass_onlyB(AnyGC* obj__) {
    return _box(DeepMixinClass_onlyB(static_cast<DeepMixinClassValue*>(obj__)));
}

AnyGC* _vptr_wrap_DeepMixinClass_onlyC(AnyGC* obj__) {
    return _box(DeepMixinClass_onlyC(static_cast<DeepMixinClassValue*>(obj__)));
}

AnyGC* _vptr_wrap_DeepMixinClass_allLayers(AnyGC* obj__) {
    return _box(DeepMixinClass_allLayers(static_cast<DeepMixinClassValue*>(obj__)));
}

static bool _DeepMixinClass_vptr_registered = []{ DeepMixinClassValue::_vptrMap["layer"] = reinterpret_cast<void*>(&_vptr_wrap_DeepMixinClass_layer); DeepMixinClassValue::_vptrMap["onlyA"] = reinterpret_cast<void*>(&_vptr_wrap_DeepMixinClass_onlyA); DeepMixinClassValue::_vptrMap["onlyB"] = reinterpret_cast<void*>(&_vptr_wrap_DeepMixinClass_onlyB); DeepMixinClassValue::_vptrMap["onlyC"] = reinterpret_cast<void*>(&_vptr_wrap_DeepMixinClass_onlyC); DeepMixinClassValue::_vptrMap["allLayers"] = reinterpret_cast<void*>(&_vptr_wrap_DeepMixinClass_allLayers); return true; }();
DeepMixinClassValue* DeepMixinClass_new(DeepMixinClassValue* this__) {
    auto this_ = this__;
    if (DeepMixinClassValue::_vptrMap.empty()) {
        DeepMixinClassValue::_vptrMap["layer"] = reinterpret_cast<void*>(&_vptr_wrap_DeepMixinClass_layer);
        DeepMixinClassValue::_vptrMap["onlyA"] = reinterpret_cast<void*>(&_vptr_wrap_DeepMixinClass_onlyA);
        DeepMixinClassValue::_vptrMap["onlyB"] = reinterpret_cast<void*>(&_vptr_wrap_DeepMixinClass_onlyB);
        DeepMixinClassValue::_vptrMap["onlyC"] = reinterpret_cast<void*>(&_vptr_wrap_DeepMixinClass_onlyC);
        DeepMixinClassValue::_vptrMap["allLayers"] = reinterpret_cast<void*>(&_vptr_wrap_DeepMixinClass_allLayers);
    }
    return this_;
}

std::string DeepMixinClass_allLayers(DeepMixinClassValue* this__) {
    auto this_ = this__;
    return dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["layer"]))(this_))) + dart_str(std::string("-")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["onlyA"]))(this_))) + dart_str(std::string("-")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["onlyB"]))(this_))) + dart_str(std::string("-")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["onlyC"]))(this_)));
}

template<typename T>
AnyGC* _vptr_wrap_Box_get_value(AnyGC* obj__) {
    return _box(Box_get_value<T>(static_cast<BoxValue<T>*>(obj__)));
}

template<typename T>
AnyGC* _vptr_wrap_Box_mapValue(AnyGC* obj__, AnyGC* arg0) {
    _TypeFnAdapter1<T> _adapter0(static_cast<TypeFunction*>(arg0));
    return _box(Box_mapValue<T, AnyGC*>(static_cast<BoxValue<T>*>(obj__), &_adapter0));
}

template<typename T>
AnyGC* _vptr_wrap_Box_describe(AnyGC* obj__) {
    return _box(Box_describe<T>(static_cast<BoxValue<T>*>(obj__)));
}

template<typename T>
AnyGC* _vptr_wrap_Box_test(AnyGC* obj__, AnyGC* arg0) {
    return _box(Box_test<T>(static_cast<BoxValue<T>*>(obj__), static_cast<TypeFunction1<bool, T>*>(arg0)));
}

template<typename T>
AnyGC* _vptr_wrap_Box_toString(AnyGC* obj__) {
    return _box(Box_toString<T>(static_cast<BoxValue<T>*>(obj__)));
}

template<typename T> void _register_Box_vptr() {
    if (BoxValue<T>::_vptrMap.empty()) {
        BoxValue<T>::_vptrMap["get_value"] = reinterpret_cast<void*>(&_vptr_wrap_Box_get_value<T>);
        BoxValue<T>::_vptrMap["mapValue"] = reinterpret_cast<void*>(&_vptr_wrap_Box_mapValue<T>);
        BoxValue<T>::_vptrMap["describe"] = reinterpret_cast<void*>(&_vptr_wrap_Box_describe<T>);
        BoxValue<T>::_vptrMap["test"] = reinterpret_cast<void*>(&_vptr_wrap_Box_test<T>);
        BoxValue<T>::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_Box_toString<T>);
    }
}
template<typename T>
BoxValue<T>* Box_new(BoxValue<T>* this__, T value) {
    auto this_ = this__;
    if (BoxValue<T>::_vptrMap.empty()) {
        BoxValue<T>::_vptrMap["get_value"] = reinterpret_cast<void*>(&_vptr_wrap_Box_get_value<T>);
        BoxValue<T>::_vptrMap["mapValue"] = reinterpret_cast<void*>(&_vptr_wrap_Box_mapValue<T>);
        BoxValue<T>::_vptrMap["describe"] = reinterpret_cast<void*>(&_vptr_wrap_Box_describe<T>);
        BoxValue<T>::_vptrMap["test"] = reinterpret_cast<void*>(&_vptr_wrap_Box_test<T>);
        BoxValue<T>::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_Box_toString<T>);
    }
    this_->value = value;
    return this_;
}

template<typename T>
std::string Box_toString(BoxValue<T>* this__) {
    auto this_ = this__;
    return dart_str(std::string("Box(")) + dart_str(this_->value) + dart_str(std::string(")"));
}

AnyGC* _vptr_wrap_Identifiable_get_id(AnyGC* obj__) {
    return _box(Identifiable_get_id(static_cast<IdentifiableValue*>(obj__)));
}

static bool _Identifiable_vptr_registered = []{ IdentifiableValue::_vptrMap["get_id"] = reinterpret_cast<void*>(&_vptr_wrap_Identifiable_get_id); return true; }();
IdentifiableValue* Identifiable_new(IdentifiableValue* this__) {
    auto this_ = this__;
    if (IdentifiableValue::_vptrMap.empty()) {
        IdentifiableValue::_vptrMap["get_id"] = reinterpret_cast<void*>(&_vptr_wrap_Identifiable_get_id);
    }
    return this_;
}

std::string Identifiable_get_id(IdentifiableValue* this__) {
    auto this_ = this__;
    return "";
}

AnyGC* _vptr_wrap_Describable_describe(AnyGC* obj__) {
    return _box(Describable_describe(static_cast<DescribableValue*>(obj__)));
}

static bool _Describable_vptr_registered = []{ DescribableValue::_vptrMap["describe"] = reinterpret_cast<void*>(&_vptr_wrap_Describable_describe); return true; }();
DescribableValue* Describable_new(DescribableValue* this__) {
    auto this_ = this__;
    if (DescribableValue::_vptrMap.empty()) {
        DescribableValue::_vptrMap["describe"] = reinterpret_cast<void*>(&_vptr_wrap_Describable_describe);
    }
    return this_;
}

std::string Describable_describe(DescribableValue* this__) {
    auto this_ = this__;
    throw DartUnimplementedError(dart_str(std::string("abstract method Describable.describe")));
}

AnyGC* _vptr_wrap_Resource_get_id(AnyGC* obj__) {
    return _box(Resource_get_id(static_cast<ResourceValue*>(obj__)));
}

AnyGC* _vptr_wrap_Resource_describe(AnyGC* obj__) {
    return _box(Resource_describe(static_cast<ResourceValue*>(obj__)));
}

static bool _Resource_vptr_registered = []{ ResourceValue::_vptrMap["get_id"] = reinterpret_cast<void*>(&_vptr_wrap_Resource_get_id); ResourceValue::_vptrMap["describe"] = reinterpret_cast<void*>(&_vptr_wrap_Resource_describe); return true; }();
ResourceValue* Resource_new(ResourceValue* this__, std::string id, std::string type) {
    auto this_ = this__;
    if (ResourceValue::_vptrMap.empty()) {
        ResourceValue::_vptrMap["get_id"] = reinterpret_cast<void*>(&_vptr_wrap_Resource_get_id);
        ResourceValue::_vptrMap["describe"] = reinterpret_cast<void*>(&_vptr_wrap_Resource_describe);
    }
    this_->id = id;
    this_->type = type;
    return this_;
}

std::string Resource_describe(ResourceValue* this__) {
    auto this_ = this__;
    return dart_str(std::string("Resource(")) + dart_str(this_->id) + dart_str(std::string(", type=")) + dart_str(this_->type) + dart_str(std::string(")"));
}

AnyGC* _vptr_wrap_TaggedResource_get_id(AnyGC* obj__) {
    return _box(TaggedResource_get_id(static_cast<TaggedResourceValue*>(obj__)));
}

AnyGC* _vptr_wrap_TaggedResource_describe(AnyGC* obj__) {
    return _box(TaggedResource_describe(static_cast<TaggedResourceValue*>(obj__)));
}

AnyGC* _vptr_wrap_TaggedResource_tag(AnyGC* obj__, AnyGC* arg0) {
    TaggedResource_tag(static_cast<TaggedResourceValue*>(obj__), dynAs<std::string>(arg0));
    return nullptr;
}

AnyGC* _vptr_wrap_TaggedResource_get_allTags(AnyGC* obj__) {
    return _box(TaggedResource_get_allTags(static_cast<TaggedResourceValue*>(obj__)));
}

AnyGC* _vptr_wrap_TaggedResource_hasTag(AnyGC* obj__, AnyGC* arg0) {
    return _box(TaggedResource_hasTag(static_cast<TaggedResourceValue*>(obj__), dynAs<std::string>(arg0)));
}

static bool _TaggedResource_vptr_registered = []{ TaggedResourceValue::_vptrMap["get_id"] = reinterpret_cast<void*>(&_vptr_wrap_TaggedResource_get_id); TaggedResourceValue::_vptrMap["describe"] = reinterpret_cast<void*>(&_vptr_wrap_TaggedResource_describe); TaggedResourceValue::_vptrMap["tag"] = reinterpret_cast<void*>(&_vptr_wrap_TaggedResource_tag); TaggedResourceValue::_vptrMap["get_allTags"] = reinterpret_cast<void*>(&_vptr_wrap_TaggedResource_get_allTags); TaggedResourceValue::_vptrMap["hasTag"] = reinterpret_cast<void*>(&_vptr_wrap_TaggedResource_hasTag); return true; }();
TaggedResourceValue* TaggedResource_new(TaggedResourceValue* this__, std::string id, std::string type) {
    auto this_ = this__;
    if (TaggedResourceValue::_vptrMap.empty()) {
        TaggedResourceValue::_vptrMap["get_id"] = reinterpret_cast<void*>(&_vptr_wrap_TaggedResource_get_id);
        TaggedResourceValue::_vptrMap["describe"] = reinterpret_cast<void*>(&_vptr_wrap_TaggedResource_describe);
        TaggedResourceValue::_vptrMap["tag"] = reinterpret_cast<void*>(&_vptr_wrap_TaggedResource_tag);
        TaggedResourceValue::_vptrMap["get_allTags"] = reinterpret_cast<void*>(&_vptr_wrap_TaggedResource_get_allTags);
        TaggedResourceValue::_vptrMap["hasTag"] = reinterpret_cast<void*>(&_vptr_wrap_TaggedResource_hasTag);
    }
    Resource_new(this_, id, type);
    this_->_tags = GC::allocateLocal(new StaticList<std::string>());
    return this_;
}

std::string TaggedResource_describe(TaggedResourceValue* this__) {
    auto this_ = this__;
    return dart_str(Resource_describe(this_)) + dart_str(std::string(", tags=")) + dart_str((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_allTags"]))(this_));
}

AnyGC* _vptr_wrap_BaseProcessor_process(AnyGC* obj__, AnyGC* arg0) {
    return _box(BaseProcessor_process(static_cast<BaseProcessorValue*>(obj__), dynAs<std::string>(arg0)));
}

AnyGC* _vptr_wrap_BaseProcessor_get_processorName(AnyGC* obj__) {
    return _box(BaseProcessor_get_processorName(static_cast<BaseProcessorValue*>(obj__)));
}

static bool _BaseProcessor_vptr_registered = []{ BaseProcessorValue::_vptrMap["process"] = reinterpret_cast<void*>(&_vptr_wrap_BaseProcessor_process); BaseProcessorValue::_vptrMap["get_processorName"] = reinterpret_cast<void*>(&_vptr_wrap_BaseProcessor_get_processorName); return true; }();
BaseProcessorValue* BaseProcessor_new(BaseProcessorValue* this__) {
    auto this_ = this__;
    if (BaseProcessorValue::_vptrMap.empty()) {
        BaseProcessorValue::_vptrMap["process"] = reinterpret_cast<void*>(&_vptr_wrap_BaseProcessor_process);
        BaseProcessorValue::_vptrMap["get_processorName"] = reinterpret_cast<void*>(&_vptr_wrap_BaseProcessor_get_processorName);
    }
    return this_;
}

std::string BaseProcessor_process(BaseProcessorValue* this__, std::string input) {
    auto this_ = this__;
    return dart_str_trim(input);
}

std::string BaseProcessor_get_processorName(BaseProcessorValue* this__) {
    auto this_ = this__;
    return std::string("Base");
}

AnyGC* _vptr_wrap_UpperProcessor_process(AnyGC* obj__, AnyGC* arg0) {
    return _box(UpperProcessor_process(static_cast<UpperProcessorValue*>(obj__), dynAs<std::string>(arg0)));
}

AnyGC* _vptr_wrap_UpperProcessor_get_processorName(AnyGC* obj__) {
    return _box(UpperProcessor_get_processorName(static_cast<UpperProcessorValue*>(obj__)));
}

static bool _UpperProcessor_vptr_registered = []{ UpperProcessorValue::_vptrMap["process"] = reinterpret_cast<void*>(&_vptr_wrap_UpperProcessor_process); UpperProcessorValue::_vptrMap["get_processorName"] = reinterpret_cast<void*>(&_vptr_wrap_UpperProcessor_get_processorName); return true; }();
UpperProcessorValue* UpperProcessor_new(UpperProcessorValue* this__) {
    auto this_ = this__;
    if (UpperProcessorValue::_vptrMap.empty()) {
        UpperProcessorValue::_vptrMap["process"] = reinterpret_cast<void*>(&_vptr_wrap_UpperProcessor_process);
        UpperProcessorValue::_vptrMap["get_processorName"] = reinterpret_cast<void*>(&_vptr_wrap_UpperProcessor_get_processorName);
    }
    BaseProcessor_new(this_);
    return this_;
}

std::string UpperProcessor_process(UpperProcessorValue* this__, std::string input) {
    auto this_ = this__;
    return dart_str_toUpper(BaseProcessor_process(this_, input));
}

std::string UpperProcessor_get_processorName(UpperProcessorValue* this__) {
    auto this_ = this__;
    return dart_str(BaseProcessor_get_processorName(this_)) + dart_str(std::string("->Upper"));
}

AnyGC* _vptr_wrap_PrefixProcessor_process(AnyGC* obj__, AnyGC* arg0) {
    return _box(PrefixProcessor_process(static_cast<PrefixProcessorValue*>(obj__), dynAs<std::string>(arg0)));
}

AnyGC* _vptr_wrap_PrefixProcessor_get_processorName(AnyGC* obj__) {
    return _box(PrefixProcessor_get_processorName(static_cast<PrefixProcessorValue*>(obj__)));
}

static bool _PrefixProcessor_vptr_registered = []{ PrefixProcessorValue::_vptrMap["process"] = reinterpret_cast<void*>(&_vptr_wrap_PrefixProcessor_process); PrefixProcessorValue::_vptrMap["get_processorName"] = reinterpret_cast<void*>(&_vptr_wrap_PrefixProcessor_get_processorName); return true; }();
PrefixProcessorValue* PrefixProcessor_new(PrefixProcessorValue* this__, std::string prefix) {
    auto this_ = this__;
    if (PrefixProcessorValue::_vptrMap.empty()) {
        PrefixProcessorValue::_vptrMap["process"] = reinterpret_cast<void*>(&_vptr_wrap_PrefixProcessor_process);
        PrefixProcessorValue::_vptrMap["get_processorName"] = reinterpret_cast<void*>(&_vptr_wrap_PrefixProcessor_get_processorName);
    }
    this_->prefix = prefix;
    UpperProcessor_new(this_);
    return this_;
}

std::string PrefixProcessor_process(PrefixProcessorValue* this__, std::string input) {
    auto this_ = this__;
    return dart_str(this_->prefix) + dart_str(std::string(":")) + dart_str(UpperProcessor_process(this_, input));
}

std::string PrefixProcessor_get_processorName(PrefixProcessorValue* this__) {
    auto this_ = this__;
    return dart_str(UpperProcessor_get_processorName(this_)) + dart_str(std::string("->Prefix(")) + dart_str(this_->prefix) + dart_str(std::string(")"));
}

AnyGC* _vptr_wrap_Amount_get_numericValue(AnyGC* obj__) {
    return _box(Amount_get_numericValue(static_cast<AmountValue*>(obj__)));
}

AnyGC* _vptr_wrap_Amount_addValues(AnyGC* obj__, AnyGC* arg0) {
    return _box(Amount_addValues(static_cast<AmountValue*>(obj__), dynAs<int64_t>(arg0)));
}

AnyGC* _vptr_wrap_Amount_doubleValue(AnyGC* obj__) {
    return _box(Amount_doubleValue(static_cast<AmountValue*>(obj__)));
}

AnyGC* _vptr_wrap_Amount_add(AnyGC* obj__, AnyGC* arg0) {
    return _box(Amount_add(static_cast<AmountValue*>(obj__), static_cast<AmountValue*>(arg0)));
}

AnyGC* _vptr_wrap_Amount_sub(AnyGC* obj__, AnyGC* arg0) {
    return _box(Amount_sub(static_cast<AmountValue*>(obj__), static_cast<AmountValue*>(arg0)));
}

AnyGC* _vptr_wrap_Amount_lt(AnyGC* obj__, AnyGC* arg0) {
    return _box(Amount_lt(static_cast<AmountValue*>(obj__), static_cast<AmountValue*>(arg0)));
}

AnyGC* _vptr_wrap_Amount_gt(AnyGC* obj__, AnyGC* arg0) {
    return _box(Amount_gt(static_cast<AmountValue*>(obj__), static_cast<AmountValue*>(arg0)));
}

AnyGC* _vptr_wrap_Amount_toString(AnyGC* obj__) {
    return _box(Amount_toString(static_cast<AmountValue*>(obj__)));
}

static bool _Amount_vptr_registered = []{ AmountValue::_vptrMap["get_numericValue"] = reinterpret_cast<void*>(&_vptr_wrap_Amount_get_numericValue); AmountValue::_vptrMap["addValues"] = reinterpret_cast<void*>(&_vptr_wrap_Amount_addValues); AmountValue::_vptrMap["doubleValue"] = reinterpret_cast<void*>(&_vptr_wrap_Amount_doubleValue); AmountValue::_vptrMap["+"] = reinterpret_cast<void*>(&_vptr_wrap_Amount_add); AmountValue::_vptrMap["-"] = reinterpret_cast<void*>(&_vptr_wrap_Amount_sub); AmountValue::_vptrMap["<"] = reinterpret_cast<void*>(&_vptr_wrap_Amount_lt); AmountValue::_vptrMap[">"] = reinterpret_cast<void*>(&_vptr_wrap_Amount_gt); AmountValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_Amount_toString); return true; }();
AmountValue* Amount_new(AmountValue* this__, int64_t numericValue) {
    auto this_ = this__;
    if (AmountValue::_vptrMap.empty()) {
        AmountValue::_vptrMap["get_numericValue"] = reinterpret_cast<void*>(&_vptr_wrap_Amount_get_numericValue);
        AmountValue::_vptrMap["addValues"] = reinterpret_cast<void*>(&_vptr_wrap_Amount_addValues);
        AmountValue::_vptrMap["doubleValue"] = reinterpret_cast<void*>(&_vptr_wrap_Amount_doubleValue);
        AmountValue::_vptrMap["+"] = reinterpret_cast<void*>(&_vptr_wrap_Amount_add);
        AmountValue::_vptrMap["-"] = reinterpret_cast<void*>(&_vptr_wrap_Amount_sub);
        AmountValue::_vptrMap["<"] = reinterpret_cast<void*>(&_vptr_wrap_Amount_lt);
        AmountValue::_vptrMap[">"] = reinterpret_cast<void*>(&_vptr_wrap_Amount_gt);
        AmountValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_Amount_toString);
    }
    this_->numericValue = numericValue;
    return this_;
}

AmountValue* Amount_add(AmountValue* this__, AmountValue* other) {
    auto this_ = this__;
    return Amount_new(GC::allocateLocal(new AmountValue()), (this_->numericValue + other->numericValue));
}

AmountValue* Amount_sub(AmountValue* this__, AmountValue* other) {
    auto this_ = this__;
    return Amount_new(GC::allocateLocal(new AmountValue()), (this_->numericValue - other->numericValue));
}

bool Amount_lt(AmountValue* this__, AmountValue* other) {
    auto this_ = this__;
    return (this_->numericValue < other->numericValue);
}

bool Amount_gt(AmountValue* this__, AmountValue* other) {
    auto this_ = this__;
    return (this_->numericValue > other->numericValue);
}

std::string Amount_toString(AmountValue* this__) {
    auto this_ = this__;
    return dart_str(std::string("Amount(")) + dart_str(this_->numericValue) + dart_str(std::string(")"));
}

AnyGC* _vptr_wrap_Vehicle_toString(AnyGC* obj__) {
    return _box(Vehicle_toString(static_cast<VehicleValue*>(obj__)));
}

static bool _Vehicle_vptr_registered = []{ VehicleValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_Vehicle_toString); return true; }();
VehicleValue* Vehicle_new(VehicleValue* this__, std::string make, int64_t year) {
    auto this_ = this__;
    if (VehicleValue::_vptrMap.empty()) {
        VehicleValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_Vehicle_toString);
    }
    this_->make = make;
    this_->year = year;
    return this_;
}

std::string Vehicle_toString(VehicleValue* this__) {
    auto this_ = this__;
    return dart_str(std::string("Vehicle(")) + dart_str(this_->make) + dart_str(std::string(", ")) + dart_str(this_->year) + dart_str(std::string(")"));
}

AnyGC* _vptr_wrap_Car_toString(AnyGC* obj__) {
    return _box(Car_toString(static_cast<CarValue*>(obj__)));
}

AnyGC* _vptr_wrap_Car_toPrettyString(AnyGC* obj__) {
    return _box(Car_toPrettyString(static_cast<CarValue*>(obj__)));
}

AnyGC* _vptr_wrap_Car_prettyPrint(AnyGC* obj__) {
    Car_prettyPrint(static_cast<CarValue*>(obj__));
    return nullptr;
}

static bool _Car_vptr_registered = []{ CarValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_Car_toString); CarValue::_vptrMap["toPrettyString"] = reinterpret_cast<void*>(&_vptr_wrap_Car_toPrettyString); CarValue::_vptrMap["prettyPrint"] = reinterpret_cast<void*>(&_vptr_wrap_Car_prettyPrint); return true; }();
CarValue* Car_new(CarValue* this__, std::string make, int64_t year, int64_t doors) {
    auto this_ = this__;
    if (CarValue::_vptrMap.empty()) {
        CarValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_Car_toString);
        CarValue::_vptrMap["toPrettyString"] = reinterpret_cast<void*>(&_vptr_wrap_Car_toPrettyString);
        CarValue::_vptrMap["prettyPrint"] = reinterpret_cast<void*>(&_vptr_wrap_Car_prettyPrint);
    }
    this_->doors = doors;
    Vehicle_new(this_, make, year);
    return this_;
}

std::string Car_toPrettyString(CarValue* this__) {
    auto this_ = this__;
    return dart_str(std::string("Car[")) + dart_str(this_->make) + dart_str(std::string(", ")) + dart_str(this_->year) + dart_str(std::string(", ")) + dart_str(this_->doors) + dart_str(std::string("dr]"));
}

std::string Car_toString(CarValue* this__) {
    auto this_ = this__;
    return dart_str(std::string("Car(")) + dart_str(this_->make) + dart_str(std::string(", ")) + dart_str(this_->year) + dart_str(std::string(", ")) + dart_str(this_->doors) + dart_str(std::string("dr)"));
}

AnyGC* _vptr_wrap_ElectricCar_toString(AnyGC* obj__) {
    return _box(ElectricCar_toString(static_cast<ElectricCarValue*>(obj__)));
}

AnyGC* _vptr_wrap_ElectricCar_toPrettyString(AnyGC* obj__) {
    return _box(ElectricCar_toPrettyString(static_cast<ElectricCarValue*>(obj__)));
}

AnyGC* _vptr_wrap_ElectricCar_prettyPrint(AnyGC* obj__) {
    ElectricCar_prettyPrint(static_cast<ElectricCarValue*>(obj__));
    return nullptr;
}

static bool _ElectricCar_vptr_registered = []{ ElectricCarValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_ElectricCar_toString); ElectricCarValue::_vptrMap["toPrettyString"] = reinterpret_cast<void*>(&_vptr_wrap_ElectricCar_toPrettyString); ElectricCarValue::_vptrMap["prettyPrint"] = reinterpret_cast<void*>(&_vptr_wrap_ElectricCar_prettyPrint); return true; }();
ElectricCarValue* ElectricCar_new(ElectricCarValue* this__, std::string make, int64_t year, int64_t doors, int64_t range) {
    auto this_ = this__;
    if (ElectricCarValue::_vptrMap.empty()) {
        ElectricCarValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_ElectricCar_toString);
        ElectricCarValue::_vptrMap["toPrettyString"] = reinterpret_cast<void*>(&_vptr_wrap_ElectricCar_toPrettyString);
        ElectricCarValue::_vptrMap["prettyPrint"] = reinterpret_cast<void*>(&_vptr_wrap_ElectricCar_prettyPrint);
    }
    this_->range = range;
    Car_new(this_, make, year, doors);
    return this_;
}

std::string ElectricCar_toPrettyString(ElectricCarValue* this__) {
    auto this_ = this__;
    return dart_str(Car_toPrettyString(this_)) + dart_str(std::string("+EV(")) + dart_str(this_->range) + dart_str(std::string("km)"));
}

std::string ElectricCar_toString(ElectricCarValue* this__) {
    auto this_ = this__;
    return dart_str(std::string("ElectricCar(")) + dart_str(this_->make) + dart_str(std::string(", ")) + dart_str(this_->year) + dart_str(std::string(", ")) + dart_str(this_->doors) + dart_str(std::string("dr, ")) + dart_str(this_->range) + dart_str(std::string("km)"));
}

AnyGC* _vptr_wrap_Measurable_measure(AnyGC* obj__) {
    return _box(Measurable_measure(static_cast<MeasurableValue*>(obj__)));
}

static bool _Measurable_vptr_registered = []{ MeasurableValue::_vptrMap["measure"] = reinterpret_cast<void*>(&_vptr_wrap_Measurable_measure); return true; }();
MeasurableValue* Measurable_new(MeasurableValue* this__) {
    auto this_ = this__;
    if (MeasurableValue::_vptrMap.empty()) {
        MeasurableValue::_vptrMap["measure"] = reinterpret_cast<void*>(&_vptr_wrap_Measurable_measure);
    }
    return this_;
}

double Measurable_measure(MeasurableValue* this__) {
    auto this_ = this__;
    throw DartUnimplementedError(dart_str(std::string("abstract method Measurable.measure")));
}

AnyGC* _vptr_wrap_Segment_measure(AnyGC* obj__) {
    return _box(Segment_measure(static_cast<SegmentValue*>(obj__)));
}

AnyGC* _vptr_wrap_Segment_scale(AnyGC* obj__, AnyGC* arg0) {
    return _box(Segment_scale(static_cast<SegmentValue*>(obj__), dynAs<double>(arg0)));
}

AnyGC* _vptr_wrap_Segment_measureInfo(AnyGC* obj__) {
    return _box(Segment_measureInfo(static_cast<SegmentValue*>(obj__)));
}

AnyGC* _vptr_wrap_Segment_toString(AnyGC* obj__) {
    return _box(Segment_toString(static_cast<SegmentValue*>(obj__)));
}

static bool _Segment_vptr_registered = []{ SegmentValue::_vptrMap["measure"] = reinterpret_cast<void*>(&_vptr_wrap_Segment_measure); SegmentValue::_vptrMap["scale"] = reinterpret_cast<void*>(&_vptr_wrap_Segment_scale); SegmentValue::_vptrMap["measureInfo"] = reinterpret_cast<void*>(&_vptr_wrap_Segment_measureInfo); SegmentValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_Segment_toString); return true; }();
SegmentValue* Segment_new(SegmentValue* this__, double length) {
    auto this_ = this__;
    if (SegmentValue::_vptrMap.empty()) {
        SegmentValue::_vptrMap["measure"] = reinterpret_cast<void*>(&_vptr_wrap_Segment_measure);
        SegmentValue::_vptrMap["scale"] = reinterpret_cast<void*>(&_vptr_wrap_Segment_scale);
        SegmentValue::_vptrMap["measureInfo"] = reinterpret_cast<void*>(&_vptr_wrap_Segment_measureInfo);
        SegmentValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_Segment_toString);
    }
    this_->length = length;
    Measurable_new(this_);
    return this_;
}

double Segment_measure(SegmentValue* this__) {
    auto this_ = this__;
    return this_->length;
}

std::string Segment_toString(SegmentValue* this__) {
    auto this_ = this__;
    return dart_str(std::string("Segment(")) + dart_str(this_->length) + dart_str(std::string(", ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["measureInfo"]))(this_))) + dart_str(std::string(")"));
}

AnyGC* _vptr_wrap_WeightedSegment_measure(AnyGC* obj__) {
    return _box(WeightedSegment_measure(static_cast<WeightedSegmentValue*>(obj__)));
}

AnyGC* _vptr_wrap_WeightedSegment_scale(AnyGC* obj__, AnyGC* arg0) {
    return _box(WeightedSegment_scale(static_cast<WeightedSegmentValue*>(obj__), dynAs<double>(arg0)));
}

AnyGC* _vptr_wrap_WeightedSegment_measureInfo(AnyGC* obj__) {
    return _box(WeightedSegment_measureInfo(static_cast<WeightedSegmentValue*>(obj__)));
}

AnyGC* _vptr_wrap_WeightedSegment_toString(AnyGC* obj__) {
    return _box(WeightedSegment_toString(static_cast<WeightedSegmentValue*>(obj__)));
}

static bool _WeightedSegment_vptr_registered = []{ WeightedSegmentValue::_vptrMap["measure"] = reinterpret_cast<void*>(&_vptr_wrap_WeightedSegment_measure); WeightedSegmentValue::_vptrMap["scale"] = reinterpret_cast<void*>(&_vptr_wrap_WeightedSegment_scale); WeightedSegmentValue::_vptrMap["measureInfo"] = reinterpret_cast<void*>(&_vptr_wrap_WeightedSegment_measureInfo); WeightedSegmentValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_WeightedSegment_toString); return true; }();
WeightedSegmentValue* WeightedSegment_new(WeightedSegmentValue* this__, double length, double weight) {
    auto this_ = this__;
    if (WeightedSegmentValue::_vptrMap.empty()) {
        WeightedSegmentValue::_vptrMap["measure"] = reinterpret_cast<void*>(&_vptr_wrap_WeightedSegment_measure);
        WeightedSegmentValue::_vptrMap["scale"] = reinterpret_cast<void*>(&_vptr_wrap_WeightedSegment_scale);
        WeightedSegmentValue::_vptrMap["measureInfo"] = reinterpret_cast<void*>(&_vptr_wrap_WeightedSegment_measureInfo);
        WeightedSegmentValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_WeightedSegment_toString);
    }
    this_->weight = weight;
    Segment_new(this_, length);
    return this_;
}

double WeightedSegment_measure(WeightedSegmentValue* this__) {
    auto this_ = this__;
    return (this_->length * this_->weight);
}

std::string WeightedSegment_toString(WeightedSegmentValue* this__) {
    auto this_ = this__;
    return dart_str(std::string("WeightedSegment(len=")) + dart_str(this_->length) + dart_str(std::string(", w=")) + dart_str(this_->weight) + dart_str(std::string(", ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["measureInfo"]))(this_))) + dart_str(std::string(")"));
}

AnyGC* _vptr_wrap_MultiMixinEntity_get_label(AnyGC* obj__) {
    return _box(MultiMixinEntity_get_label(static_cast<MultiMixinEntityValue*>(obj__)));
}

AnyGC* _vptr_wrap_MultiMixinEntity_greet(AnyGC* obj__) {
    return _box(MultiMixinEntity_greet(static_cast<MultiMixinEntityValue*>(obj__)));
}

AnyGC* _vptr_wrap_MultiMixinEntity_info(AnyGC* obj__) {
    return _box(MultiMixinEntity_info(static_cast<MultiMixinEntityValue*>(obj__)));
}

AnyGC* _vptr_wrap_MultiMixinEntity_fullInfo(AnyGC* obj__) {
    return _box(MultiMixinEntity_fullInfo(static_cast<MultiMixinEntityValue*>(obj__)));
}

static bool _MultiMixinEntity_vptr_registered = []{ MultiMixinEntityValue::_vptrMap["get_label"] = reinterpret_cast<void*>(&_vptr_wrap_MultiMixinEntity_get_label); MultiMixinEntityValue::_vptrMap["greet"] = reinterpret_cast<void*>(&_vptr_wrap_MultiMixinEntity_greet); MultiMixinEntityValue::_vptrMap["info"] = reinterpret_cast<void*>(&_vptr_wrap_MultiMixinEntity_info); MultiMixinEntityValue::_vptrMap["fullInfo"] = reinterpret_cast<void*>(&_vptr_wrap_MultiMixinEntity_fullInfo); return true; }();
MultiMixinEntityValue* MultiMixinEntity_new(MultiMixinEntityValue* this__) {
    auto this_ = this__;
    if (MultiMixinEntityValue::_vptrMap.empty()) {
        MultiMixinEntityValue::_vptrMap["get_label"] = reinterpret_cast<void*>(&_vptr_wrap_MultiMixinEntity_get_label);
        MultiMixinEntityValue::_vptrMap["greet"] = reinterpret_cast<void*>(&_vptr_wrap_MultiMixinEntity_greet);
        MultiMixinEntityValue::_vptrMap["info"] = reinterpret_cast<void*>(&_vptr_wrap_MultiMixinEntity_info);
        MultiMixinEntityValue::_vptrMap["fullInfo"] = reinterpret_cast<void*>(&_vptr_wrap_MultiMixinEntity_fullInfo);
    }
    return this_;
}

std::string MultiMixinEntity_get_label(MultiMixinEntityValue* this__) {
    auto this_ = this__;
    return std::string("Entity");
}

std::string MultiMixinEntity_fullInfo(MultiMixinEntityValue* this__) {
    auto this_ = this__;
    return dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["greet"]))(this_))) + dart_str(std::string(" | ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["info"]))(this_)));
}

AnyGC* _vptr_wrap_Encoder_encode(AnyGC* obj__, AnyGC* arg0) {
    return _box(Encoder_encode(static_cast<EncoderValue*>(obj__), dynAs<std::string>(arg0)));
}

static bool _Encoder_vptr_registered = []{ EncoderValue::_vptrMap["encode"] = reinterpret_cast<void*>(&_vptr_wrap_Encoder_encode); return true; }();
EncoderValue* Encoder_new(EncoderValue* this__) {
    auto this_ = this__;
    if (EncoderValue::_vptrMap.empty()) {
        EncoderValue::_vptrMap["encode"] = reinterpret_cast<void*>(&_vptr_wrap_Encoder_encode);
    }
    return this_;
}

std::string Encoder_encode(EncoderValue* this__, std::string input) {
    auto this_ = this__;
    throw DartUnimplementedError(dart_str(std::string("abstract method Encoder.encode")));
}

AnyGC* _vptr_wrap_MultiEncoder_encode(AnyGC* obj__, AnyGC* arg0) {
    return _box(MultiEncoder_encode(static_cast<MultiEncoderValue*>(obj__), dynAs<std::string>(arg0)));
}

AnyGC* _vptr_wrap_MultiEncoder_encodeAll(AnyGC* obj__, AnyGC* arg0) {
    return _box(MultiEncoder_encodeAll(static_cast<MultiEncoderValue*>(obj__), dynAs<std::string>(arg0)));
}

static bool _MultiEncoder_vptr_registered = []{ MultiEncoderValue::_vptrMap["encode"] = reinterpret_cast<void*>(&_vptr_wrap_MultiEncoder_encode); MultiEncoderValue::_vptrMap["encodeAll"] = reinterpret_cast<void*>(&_vptr_wrap_MultiEncoder_encodeAll); return true; }();
MultiEncoderValue* MultiEncoder_new(MultiEncoderValue* this__) {
    auto this_ = this__;
    if (MultiEncoderValue::_vptrMap.empty()) {
        MultiEncoderValue::_vptrMap["encode"] = reinterpret_cast<void*>(&_vptr_wrap_MultiEncoder_encode);
        MultiEncoderValue::_vptrMap["encodeAll"] = reinterpret_cast<void*>(&_vptr_wrap_MultiEncoder_encodeAll);
    }
    return this_;
}

std::string MultiEncoder_encodeAll(MultiEncoderValue* this__, std::string input) {
    auto this_ = this__;
    return dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["encode"]))(this_, _box(input)));
}

AnyGC* _vptr_wrap_CustomEncoder_encode(AnyGC* obj__, AnyGC* arg0) {
    return _box(CustomEncoder_encode(static_cast<CustomEncoderValue*>(obj__), dynAs<std::string>(arg0)));
}

AnyGC* _vptr_wrap_CustomEncoder_encodeAll(AnyGC* obj__, AnyGC* arg0) {
    return _box(CustomEncoder_encodeAll(static_cast<CustomEncoderValue*>(obj__), dynAs<std::string>(arg0)));
}

static bool _CustomEncoder_vptr_registered = []{ CustomEncoderValue::_vptrMap["encode"] = reinterpret_cast<void*>(&_vptr_wrap_CustomEncoder_encode); CustomEncoderValue::_vptrMap["encodeAll"] = reinterpret_cast<void*>(&_vptr_wrap_CustomEncoder_encodeAll); return true; }();
CustomEncoderValue* CustomEncoder_new(CustomEncoderValue* this__) {
    auto this_ = this__;
    if (CustomEncoderValue::_vptrMap.empty()) {
        CustomEncoderValue::_vptrMap["encode"] = reinterpret_cast<void*>(&_vptr_wrap_CustomEncoder_encode);
        CustomEncoderValue::_vptrMap["encodeAll"] = reinterpret_cast<void*>(&_vptr_wrap_CustomEncoder_encodeAll);
    }
    MultiEncoder_new(this_);
    return this_;
}

std::string CustomEncoder_encode(CustomEncoderValue* this__, std::string input) {
    auto this_ = this__;
    return dart_str(std::string("custom(")) + dart_str(MultiEncoder_encode(this_, input)) + dart_str(std::string(")"));
}

template<typename T>
AnyGC* _vptr_wrap_Container_describe(AnyGC* obj__) {
    return _box(Container_describe<T>(static_cast<ContainerValue<T>*>(obj__)));
}

template<typename T>
AnyGC* _vptr_wrap_Container_get_content(AnyGC* obj__) {
    return _box(Container_get_content<T>(static_cast<ContainerValue<T>*>(obj__)));
}

template<typename T> void _register_Container_vptr() {
    if (ContainerValue<T>::_vptrMap.empty()) {
        ContainerValue<T>::_vptrMap["describe"] = reinterpret_cast<void*>(&_vptr_wrap_Container_describe<T>);
        ContainerValue<T>::_vptrMap["get_content"] = reinterpret_cast<void*>(&_vptr_wrap_Container_get_content<T>);
    }
}
template<typename T>
ContainerValue<T>* Container_new(ContainerValue<T>* this__, T item) {
    auto this_ = this__;
    if (ContainerValue<T>::_vptrMap.empty()) {
        ContainerValue<T>::_vptrMap["describe"] = reinterpret_cast<void*>(&_vptr_wrap_Container_describe<T>);
        ContainerValue<T>::_vptrMap["get_content"] = reinterpret_cast<void*>(&_vptr_wrap_Container_get_content<T>);
    }
    this_->item = item;
    return this_;
}

template<typename T>
std::string Container_describe(ContainerValue<T>* this__) {
    auto this_ = this__;
    return dart_str(std::string("Container<")) + dart_str(std::string("TypeParameterType(Container.T%)")) + dart_str(std::string(">(")) + dart_str(this_->item) + dart_str(std::string(")"));
}

template<typename T>
T Container_get_content(ContainerValue<T>* this__) {
    auto this_ = this__;
    return this_->item;
}

template<typename T>
AnyGC* _vptr_wrap_LabeledContainer_describe(AnyGC* obj__) {
    return _box(LabeledContainer_describe<T>(static_cast<LabeledContainerValue<T>*>(obj__)));
}

template<typename T>
AnyGC* _vptr_wrap_LabeledContainer_get_content(AnyGC* obj__) {
    return _box(LabeledContainer_get_content<T>(static_cast<LabeledContainerValue<T>*>(obj__)));
}

template<typename T> void _register_LabeledContainer_vptr() {
    if (LabeledContainerValue<T>::_vptrMap.empty()) {
        LabeledContainerValue<T>::_vptrMap["describe"] = reinterpret_cast<void*>(&_vptr_wrap_LabeledContainer_describe<T>);
        LabeledContainerValue<T>::_vptrMap["get_content"] = reinterpret_cast<void*>(&_vptr_wrap_LabeledContainer_get_content<T>);
    }
}
template<typename T>
LabeledContainerValue<T>* LabeledContainer_new(LabeledContainerValue<T>* this__, T item, std::string label) {
    auto this_ = this__;
    if (LabeledContainerValue<T>::_vptrMap.empty()) {
        LabeledContainerValue<T>::_vptrMap["describe"] = reinterpret_cast<void*>(&_vptr_wrap_LabeledContainer_describe<T>);
        LabeledContainerValue<T>::_vptrMap["get_content"] = reinterpret_cast<void*>(&_vptr_wrap_LabeledContainer_get_content<T>);
    }
    this_->label = label;
    Container_new<T>(this_, item);
    return this_;
}

template<typename T>
std::string LabeledContainer_describe(LabeledContainerValue<T>* this__) {
    auto this_ = this__;
    return dart_str(std::string("Labeled[")) + dart_str(this_->label) + dart_str(std::string("]: ")) + dart_str(Container_describe(this_));
}

template<typename T>
AnyGC* _vptr_wrap_PriorityContainer_describe(AnyGC* obj__) {
    return _box(PriorityContainer_describe<T>(static_cast<PriorityContainerValue<T>*>(obj__)));
}

template<typename T>
AnyGC* _vptr_wrap_PriorityContainer_get_content(AnyGC* obj__) {
    return _box(PriorityContainer_get_content<T>(static_cast<PriorityContainerValue<T>*>(obj__)));
}

template<typename T> void _register_PriorityContainer_vptr() {
    if (PriorityContainerValue<T>::_vptrMap.empty()) {
        PriorityContainerValue<T>::_vptrMap["describe"] = reinterpret_cast<void*>(&_vptr_wrap_PriorityContainer_describe<T>);
        PriorityContainerValue<T>::_vptrMap["get_content"] = reinterpret_cast<void*>(&_vptr_wrap_PriorityContainer_get_content<T>);
    }
}
template<typename T>
PriorityContainerValue<T>* PriorityContainer_new(PriorityContainerValue<T>* this__, T item, std::string label, int64_t priority) {
    auto this_ = this__;
    if (PriorityContainerValue<T>::_vptrMap.empty()) {
        PriorityContainerValue<T>::_vptrMap["describe"] = reinterpret_cast<void*>(&_vptr_wrap_PriorityContainer_describe<T>);
        PriorityContainerValue<T>::_vptrMap["get_content"] = reinterpret_cast<void*>(&_vptr_wrap_PriorityContainer_get_content<T>);
    }
    this_->priority = priority;
    LabeledContainer_new<T>(this_, item, label);
    return this_;
}

template<typename T>
std::string PriorityContainer_describe(PriorityContainerValue<T>* this__) {
    auto this_ = this__;
    return dart_str(std::string("(P")) + dart_str(this_->priority) + dart_str(std::string(") ")) + dart_str(LabeledContainer_describe(this_));
}

AnyGC* _vptr_wrap_ChainClass_step1(AnyGC* obj__) {
    return _box(ChainClass_step1(static_cast<ChainClassValue*>(obj__)));
}

AnyGC* _vptr_wrap_ChainClass_step2(AnyGC* obj__) {
    return _box(ChainClass_step2(static_cast<ChainClassValue*>(obj__)));
}

AnyGC* _vptr_wrap_ChainClass_step3(AnyGC* obj__) {
    return _box(ChainClass_step3(static_cast<ChainClassValue*>(obj__)));
}

AnyGC* _vptr_wrap_ChainClass_fullChain(AnyGC* obj__) {
    return _box(ChainClass_fullChain(static_cast<ChainClassValue*>(obj__)));
}

static bool _ChainClass_vptr_registered = []{ ChainClassValue::_vptrMap["step1"] = reinterpret_cast<void*>(&_vptr_wrap_ChainClass_step1); ChainClassValue::_vptrMap["step2"] = reinterpret_cast<void*>(&_vptr_wrap_ChainClass_step2); ChainClassValue::_vptrMap["step3"] = reinterpret_cast<void*>(&_vptr_wrap_ChainClass_step3); ChainClassValue::_vptrMap["fullChain"] = reinterpret_cast<void*>(&_vptr_wrap_ChainClass_fullChain); return true; }();
ChainClassValue* ChainClass_new(ChainClassValue* this__) {
    auto this_ = this__;
    if (ChainClassValue::_vptrMap.empty()) {
        ChainClassValue::_vptrMap["step1"] = reinterpret_cast<void*>(&_vptr_wrap_ChainClass_step1);
        ChainClassValue::_vptrMap["step2"] = reinterpret_cast<void*>(&_vptr_wrap_ChainClass_step2);
        ChainClassValue::_vptrMap["step3"] = reinterpret_cast<void*>(&_vptr_wrap_ChainClass_step3);
        ChainClassValue::_vptrMap["fullChain"] = reinterpret_cast<void*>(&_vptr_wrap_ChainClass_fullChain);
    }
    return this_;
}

std::string ChainClass_step1(ChainClassValue* this__) {
    auto this_ = this__;
    return std::string("X1");
}

AnyGC* _vptr_wrap_ChainSubClass_step1(AnyGC* obj__) {
    return _box(ChainSubClass_step1(static_cast<ChainSubClassValue*>(obj__)));
}

AnyGC* _vptr_wrap_ChainSubClass_step2(AnyGC* obj__) {
    return _box(ChainSubClass_step2(static_cast<ChainSubClassValue*>(obj__)));
}

AnyGC* _vptr_wrap_ChainSubClass_step3(AnyGC* obj__) {
    return _box(ChainSubClass_step3(static_cast<ChainSubClassValue*>(obj__)));
}

AnyGC* _vptr_wrap_ChainSubClass_fullChain(AnyGC* obj__) {
    return _box(ChainSubClass_fullChain(static_cast<ChainSubClassValue*>(obj__)));
}

static bool _ChainSubClass_vptr_registered = []{ ChainSubClassValue::_vptrMap["step1"] = reinterpret_cast<void*>(&_vptr_wrap_ChainSubClass_step1); ChainSubClassValue::_vptrMap["step2"] = reinterpret_cast<void*>(&_vptr_wrap_ChainSubClass_step2); ChainSubClassValue::_vptrMap["step3"] = reinterpret_cast<void*>(&_vptr_wrap_ChainSubClass_step3); ChainSubClassValue::_vptrMap["fullChain"] = reinterpret_cast<void*>(&_vptr_wrap_ChainSubClass_fullChain); return true; }();
ChainSubClassValue* ChainSubClass_new(ChainSubClassValue* this__) {
    auto this_ = this__;
    if (ChainSubClassValue::_vptrMap.empty()) {
        ChainSubClassValue::_vptrMap["step1"] = reinterpret_cast<void*>(&_vptr_wrap_ChainSubClass_step1);
        ChainSubClassValue::_vptrMap["step2"] = reinterpret_cast<void*>(&_vptr_wrap_ChainSubClass_step2);
        ChainSubClassValue::_vptrMap["step3"] = reinterpret_cast<void*>(&_vptr_wrap_ChainSubClass_step3);
        ChainSubClassValue::_vptrMap["fullChain"] = reinterpret_cast<void*>(&_vptr_wrap_ChainSubClass_fullChain);
    }
    ChainClass_new(this_);
    return this_;
}

std::string ChainSubClass_step2(ChainSubClassValue* this__) {
    auto this_ = this__;
    return dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["step1"]))(this_))) + dart_str(std::string("->Y2"));
}

AnyGC* _vptr_wrap_Expression2_evaluate(AnyGC* obj__) {
    return _box(Expression2_evaluate(static_cast<Expression2Value*>(obj__)));
}

AnyGC* _vptr_wrap_Expression2_display(AnyGC* obj__) {
    return _box(Expression2_display(static_cast<Expression2Value*>(obj__)));
}

static bool _Expression2_vptr_registered = []{ Expression2Value::_vptrMap["evaluate"] = reinterpret_cast<void*>(&_vptr_wrap_Expression2_evaluate); Expression2Value::_vptrMap["display"] = reinterpret_cast<void*>(&_vptr_wrap_Expression2_display); return true; }();
Expression2Value* Expression2_new(Expression2Value* this__) {
    auto this_ = this__;
    if (Expression2Value::_vptrMap.empty()) {
        Expression2Value::_vptrMap["evaluate"] = reinterpret_cast<void*>(&_vptr_wrap_Expression2_evaluate);
        Expression2Value::_vptrMap["display"] = reinterpret_cast<void*>(&_vptr_wrap_Expression2_display);
    }
    return this_;
}

double Expression2_evaluate(Expression2Value* this__) {
    auto this_ = this__;
    throw DartUnimplementedError(dart_str(std::string("abstract method Expression2.evaluate")));
}

std::string Expression2_display(Expression2Value* this__) {
    auto this_ = this__;
    throw DartUnimplementedError(dart_str(std::string("abstract method Expression2.display")));
}

AnyGC* _vptr_wrap_NumberExpr_evaluate(AnyGC* obj__) {
    return _box(NumberExpr_evaluate(static_cast<NumberExprValue*>(obj__)));
}

AnyGC* _vptr_wrap_NumberExpr_display(AnyGC* obj__) {
    return _box(NumberExpr_display(static_cast<NumberExprValue*>(obj__)));
}

static bool _NumberExpr_vptr_registered = []{ NumberExprValue::_vptrMap["evaluate"] = reinterpret_cast<void*>(&_vptr_wrap_NumberExpr_evaluate); NumberExprValue::_vptrMap["display"] = reinterpret_cast<void*>(&_vptr_wrap_NumberExpr_display); return true; }();
NumberExprValue* NumberExpr_new(NumberExprValue* this__, double value) {
    auto this_ = this__;
    if (NumberExprValue::_vptrMap.empty()) {
        NumberExprValue::_vptrMap["evaluate"] = reinterpret_cast<void*>(&_vptr_wrap_NumberExpr_evaluate);
        NumberExprValue::_vptrMap["display"] = reinterpret_cast<void*>(&_vptr_wrap_NumberExpr_display);
    }
    this_->value = value;
    Expression2_new(this_);
    return this_;
}

double NumberExpr_evaluate(NumberExprValue* this__) {
    auto this_ = this__;
    return this_->value;
}

std::string NumberExpr_display(NumberExprValue* this__) {
    auto this_ = this__;
    return ((this_->value == static_cast<int64_t>(this_->value)) ? dart_str(static_cast<int64_t>(this_->value)) : dart_str(this_->value));
}

AnyGC* _vptr_wrap_BinaryExpr_evaluate(AnyGC* obj__) {
    return _box(BinaryExpr_evaluate(static_cast<BinaryExprValue*>(obj__)));
}

AnyGC* _vptr_wrap_BinaryExpr_display(AnyGC* obj__) {
    return _box(BinaryExpr_display(static_cast<BinaryExprValue*>(obj__)));
}

static bool _BinaryExpr_vptr_registered = []{ BinaryExprValue::_vptrMap["evaluate"] = reinterpret_cast<void*>(&_vptr_wrap_BinaryExpr_evaluate); BinaryExprValue::_vptrMap["display"] = reinterpret_cast<void*>(&_vptr_wrap_BinaryExpr_display); return true; }();
BinaryExprValue* BinaryExpr_new(BinaryExprValue* this__, Expression2Value* left, Expression2Value* right, std::string op, TypeFunction2<double, double, double>* _compute) {
    auto this_ = this__;
    if (BinaryExprValue::_vptrMap.empty()) {
        BinaryExprValue::_vptrMap["evaluate"] = reinterpret_cast<void*>(&_vptr_wrap_BinaryExpr_evaluate);
        BinaryExprValue::_vptrMap["display"] = reinterpret_cast<void*>(&_vptr_wrap_BinaryExpr_display);
    }
    this_->left = left;
    this_->right = right;
    this_->op = op;
    this_->_compute = _compute;
    Expression2_new(this_);
    return this_;
}

BinaryExprValue* BinaryExpr_new_add(Expression2Value* l, Expression2Value* r) {
    return BinaryExpr_new(GC::allocateLocal(new BinaryExprValue()), static_cast<Expression2Value*>(l), static_cast<Expression2Value*>(r), std::string("+"), static_cast<TypeFunction2<double, double, double>*>(GC::allocateLocal(static_cast<TypeFunction2<double, double, double>*>(new ClosureEnv_0()))));
}

BinaryExprValue* BinaryExpr_new_mul(Expression2Value* l, Expression2Value* r) {
    return BinaryExpr_new(GC::allocateLocal(new BinaryExprValue()), static_cast<Expression2Value*>(l), static_cast<Expression2Value*>(r), std::string("*"), static_cast<TypeFunction2<double, double, double>*>(GC::allocateLocal(static_cast<TypeFunction2<double, double, double>*>(new ClosureEnv_1()))));
}

double BinaryExpr_evaluate(BinaryExprValue* this__) {
    auto this_ = this__;
    return ([&]() { double _let0 = dynAs<double>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->left->getVptrMap()["evaluate"]))(this_->left)); double _let1 = dynAs<double>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->right->getVptrMap()["evaluate"]))(this_->right));  return this_->_compute->call(_let0, _let1); })();
}

std::string BinaryExpr_display(BinaryExprValue* this__) {
    auto this_ = this__;
    return dart_str(std::string("(")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->left->getVptrMap()["display"]))(this_->left))) + dart_str(std::string(" ")) + dart_str(this_->op) + dart_str(std::string(" ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->right->getVptrMap()["display"]))(this_->right))) + dart_str(std::string(")"));
}

AnyGC* _vptr_wrap_GameCharacter_get_maxHealth(AnyGC* obj__) {
    return _box(GameCharacter_get_maxHealth(static_cast<GameCharacterValue*>(obj__)));
}

AnyGC* _vptr_wrap_GameCharacter_get_health(AnyGC* obj__) {
    return _box(GameCharacter_get_health(static_cast<GameCharacterValue*>(obj__)));
}

AnyGC* _vptr_wrap_GameCharacter_healthBar(AnyGC* obj__) {
    return _box(GameCharacter_healthBar(static_cast<GameCharacterValue*>(obj__)));
}

AnyGC* _vptr_wrap_GameCharacter_get_maxMana(AnyGC* obj__) {
    return _box(GameCharacter_get_maxMana(static_cast<GameCharacterValue*>(obj__)));
}

AnyGC* _vptr_wrap_GameCharacter_get_mana(AnyGC* obj__) {
    return _box(GameCharacter_get_mana(static_cast<GameCharacterValue*>(obj__)));
}

AnyGC* _vptr_wrap_GameCharacter_manaBar(AnyGC* obj__) {
    return _box(GameCharacter_manaBar(static_cast<GameCharacterValue*>(obj__)));
}

AnyGC* _vptr_wrap_GameCharacter_get_maxStamina(AnyGC* obj__) {
    return _box(GameCharacter_get_maxStamina(static_cast<GameCharacterValue*>(obj__)));
}

AnyGC* _vptr_wrap_GameCharacter_get_stamina(AnyGC* obj__) {
    return _box(GameCharacter_get_stamina(static_cast<GameCharacterValue*>(obj__)));
}

AnyGC* _vptr_wrap_GameCharacter_staminaBar(AnyGC* obj__) {
    return _box(GameCharacter_staminaBar(static_cast<GameCharacterValue*>(obj__)));
}

AnyGC* _vptr_wrap_GameCharacter_statusBars(AnyGC* obj__) {
    return _box(GameCharacter_statusBars(static_cast<GameCharacterValue*>(obj__)));
}

static bool _GameCharacter_vptr_registered = []{ GameCharacterValue::_vptrMap["get_maxHealth"] = reinterpret_cast<void*>(&_vptr_wrap_GameCharacter_get_maxHealth); GameCharacterValue::_vptrMap["get_health"] = reinterpret_cast<void*>(&_vptr_wrap_GameCharacter_get_health); GameCharacterValue::_vptrMap["healthBar"] = reinterpret_cast<void*>(&_vptr_wrap_GameCharacter_healthBar); GameCharacterValue::_vptrMap["get_maxMana"] = reinterpret_cast<void*>(&_vptr_wrap_GameCharacter_get_maxMana); GameCharacterValue::_vptrMap["get_mana"] = reinterpret_cast<void*>(&_vptr_wrap_GameCharacter_get_mana); GameCharacterValue::_vptrMap["manaBar"] = reinterpret_cast<void*>(&_vptr_wrap_GameCharacter_manaBar); GameCharacterValue::_vptrMap["get_maxStamina"] = reinterpret_cast<void*>(&_vptr_wrap_GameCharacter_get_maxStamina); GameCharacterValue::_vptrMap["get_stamina"] = reinterpret_cast<void*>(&_vptr_wrap_GameCharacter_get_stamina); GameCharacterValue::_vptrMap["staminaBar"] = reinterpret_cast<void*>(&_vptr_wrap_GameCharacter_staminaBar); GameCharacterValue::_vptrMap["statusBars"] = reinterpret_cast<void*>(&_vptr_wrap_GameCharacter_statusBars); return true; }();
GameCharacterValue* GameCharacter_new(GameCharacterValue* this__, std::string name) {
    auto this_ = this__;
    if (GameCharacterValue::_vptrMap.empty()) {
        GameCharacterValue::_vptrMap["get_maxHealth"] = reinterpret_cast<void*>(&_vptr_wrap_GameCharacter_get_maxHealth);
        GameCharacterValue::_vptrMap["get_health"] = reinterpret_cast<void*>(&_vptr_wrap_GameCharacter_get_health);
        GameCharacterValue::_vptrMap["healthBar"] = reinterpret_cast<void*>(&_vptr_wrap_GameCharacter_healthBar);
        GameCharacterValue::_vptrMap["get_maxMana"] = reinterpret_cast<void*>(&_vptr_wrap_GameCharacter_get_maxMana);
        GameCharacterValue::_vptrMap["get_mana"] = reinterpret_cast<void*>(&_vptr_wrap_GameCharacter_get_mana);
        GameCharacterValue::_vptrMap["manaBar"] = reinterpret_cast<void*>(&_vptr_wrap_GameCharacter_manaBar);
        GameCharacterValue::_vptrMap["get_maxStamina"] = reinterpret_cast<void*>(&_vptr_wrap_GameCharacter_get_maxStamina);
        GameCharacterValue::_vptrMap["get_stamina"] = reinterpret_cast<void*>(&_vptr_wrap_GameCharacter_get_stamina);
        GameCharacterValue::_vptrMap["staminaBar"] = reinterpret_cast<void*>(&_vptr_wrap_GameCharacter_staminaBar);
        GameCharacterValue::_vptrMap["statusBars"] = reinterpret_cast<void*>(&_vptr_wrap_GameCharacter_statusBars);
    }
    this_->name = name;
    return this_;
}

std::string GameCharacter_statusBars(GameCharacterValue* this__) {
    auto this_ = this__;
    return dart_str(this_->name) + dart_str(std::string(": ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["healthBar"]))(this_))) + dart_str(std::string(" ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["manaBar"]))(this_))) + dart_str(std::string(" ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["staminaBar"]))(this_)));
}

AnyGC* _vptr_wrap_Warrior_get_maxHealth(AnyGC* obj__) {
    return _box(Warrior_get_maxHealth(static_cast<WarriorValue*>(obj__)));
}

AnyGC* _vptr_wrap_Warrior_get_health(AnyGC* obj__) {
    return _box(Warrior_get_health(static_cast<WarriorValue*>(obj__)));
}

AnyGC* _vptr_wrap_Warrior_healthBar(AnyGC* obj__) {
    return _box(Warrior_healthBar(static_cast<WarriorValue*>(obj__)));
}

AnyGC* _vptr_wrap_Warrior_get_maxMana(AnyGC* obj__) {
    return _box(Warrior_get_maxMana(static_cast<WarriorValue*>(obj__)));
}

AnyGC* _vptr_wrap_Warrior_get_mana(AnyGC* obj__) {
    return _box(Warrior_get_mana(static_cast<WarriorValue*>(obj__)));
}

AnyGC* _vptr_wrap_Warrior_manaBar(AnyGC* obj__) {
    return _box(Warrior_manaBar(static_cast<WarriorValue*>(obj__)));
}

AnyGC* _vptr_wrap_Warrior_get_maxStamina(AnyGC* obj__) {
    return _box(Warrior_get_maxStamina(static_cast<WarriorValue*>(obj__)));
}

AnyGC* _vptr_wrap_Warrior_get_stamina(AnyGC* obj__) {
    return _box(Warrior_get_stamina(static_cast<WarriorValue*>(obj__)));
}

AnyGC* _vptr_wrap_Warrior_staminaBar(AnyGC* obj__) {
    return _box(Warrior_staminaBar(static_cast<WarriorValue*>(obj__)));
}

AnyGC* _vptr_wrap_Warrior_statusBars(AnyGC* obj__) {
    return _box(Warrior_statusBars(static_cast<WarriorValue*>(obj__)));
}

static bool _Warrior_vptr_registered = []{ WarriorValue::_vptrMap["get_maxHealth"] = reinterpret_cast<void*>(&_vptr_wrap_Warrior_get_maxHealth); WarriorValue::_vptrMap["get_health"] = reinterpret_cast<void*>(&_vptr_wrap_Warrior_get_health); WarriorValue::_vptrMap["healthBar"] = reinterpret_cast<void*>(&_vptr_wrap_Warrior_healthBar); WarriorValue::_vptrMap["get_maxMana"] = reinterpret_cast<void*>(&_vptr_wrap_Warrior_get_maxMana); WarriorValue::_vptrMap["get_mana"] = reinterpret_cast<void*>(&_vptr_wrap_Warrior_get_mana); WarriorValue::_vptrMap["manaBar"] = reinterpret_cast<void*>(&_vptr_wrap_Warrior_manaBar); WarriorValue::_vptrMap["get_maxStamina"] = reinterpret_cast<void*>(&_vptr_wrap_Warrior_get_maxStamina); WarriorValue::_vptrMap["get_stamina"] = reinterpret_cast<void*>(&_vptr_wrap_Warrior_get_stamina); WarriorValue::_vptrMap["staminaBar"] = reinterpret_cast<void*>(&_vptr_wrap_Warrior_staminaBar); WarriorValue::_vptrMap["statusBars"] = reinterpret_cast<void*>(&_vptr_wrap_Warrior_statusBars); return true; }();
WarriorValue* Warrior_new(WarriorValue* this__, std::string name) {
    auto this_ = this__;
    if (WarriorValue::_vptrMap.empty()) {
        WarriorValue::_vptrMap["get_maxHealth"] = reinterpret_cast<void*>(&_vptr_wrap_Warrior_get_maxHealth);
        WarriorValue::_vptrMap["get_health"] = reinterpret_cast<void*>(&_vptr_wrap_Warrior_get_health);
        WarriorValue::_vptrMap["healthBar"] = reinterpret_cast<void*>(&_vptr_wrap_Warrior_healthBar);
        WarriorValue::_vptrMap["get_maxMana"] = reinterpret_cast<void*>(&_vptr_wrap_Warrior_get_maxMana);
        WarriorValue::_vptrMap["get_mana"] = reinterpret_cast<void*>(&_vptr_wrap_Warrior_get_mana);
        WarriorValue::_vptrMap["manaBar"] = reinterpret_cast<void*>(&_vptr_wrap_Warrior_manaBar);
        WarriorValue::_vptrMap["get_maxStamina"] = reinterpret_cast<void*>(&_vptr_wrap_Warrior_get_maxStamina);
        WarriorValue::_vptrMap["get_stamina"] = reinterpret_cast<void*>(&_vptr_wrap_Warrior_get_stamina);
        WarriorValue::_vptrMap["staminaBar"] = reinterpret_cast<void*>(&_vptr_wrap_Warrior_staminaBar);
        WarriorValue::_vptrMap["statusBars"] = reinterpret_cast<void*>(&_vptr_wrap_Warrior_statusBars);
    }
    GameCharacter_new(this_, name);
    return this_;
}

int64_t Warrior_get_maxHealth(WarriorValue* this__) {
    auto this_ = this__;
    return 150LL;
}

int64_t Warrior_get_maxStamina(WarriorValue* this__) {
    auto this_ = this__;
    return 120LL;
}

AnyGC* _vptr_wrap_Mage_get_maxHealth(AnyGC* obj__) {
    return _box(Mage_get_maxHealth(static_cast<MageValue*>(obj__)));
}

AnyGC* _vptr_wrap_Mage_get_health(AnyGC* obj__) {
    return _box(Mage_get_health(static_cast<MageValue*>(obj__)));
}

AnyGC* _vptr_wrap_Mage_healthBar(AnyGC* obj__) {
    return _box(Mage_healthBar(static_cast<MageValue*>(obj__)));
}

AnyGC* _vptr_wrap_Mage_get_maxMana(AnyGC* obj__) {
    return _box(Mage_get_maxMana(static_cast<MageValue*>(obj__)));
}

AnyGC* _vptr_wrap_Mage_get_mana(AnyGC* obj__) {
    return _box(Mage_get_mana(static_cast<MageValue*>(obj__)));
}

AnyGC* _vptr_wrap_Mage_manaBar(AnyGC* obj__) {
    return _box(Mage_manaBar(static_cast<MageValue*>(obj__)));
}

AnyGC* _vptr_wrap_Mage_get_maxStamina(AnyGC* obj__) {
    return _box(Mage_get_maxStamina(static_cast<MageValue*>(obj__)));
}

AnyGC* _vptr_wrap_Mage_get_stamina(AnyGC* obj__) {
    return _box(Mage_get_stamina(static_cast<MageValue*>(obj__)));
}

AnyGC* _vptr_wrap_Mage_staminaBar(AnyGC* obj__) {
    return _box(Mage_staminaBar(static_cast<MageValue*>(obj__)));
}

AnyGC* _vptr_wrap_Mage_statusBars(AnyGC* obj__) {
    return _box(Mage_statusBars(static_cast<MageValue*>(obj__)));
}

static bool _Mage_vptr_registered = []{ MageValue::_vptrMap["get_maxHealth"] = reinterpret_cast<void*>(&_vptr_wrap_Mage_get_maxHealth); MageValue::_vptrMap["get_health"] = reinterpret_cast<void*>(&_vptr_wrap_Mage_get_health); MageValue::_vptrMap["healthBar"] = reinterpret_cast<void*>(&_vptr_wrap_Mage_healthBar); MageValue::_vptrMap["get_maxMana"] = reinterpret_cast<void*>(&_vptr_wrap_Mage_get_maxMana); MageValue::_vptrMap["get_mana"] = reinterpret_cast<void*>(&_vptr_wrap_Mage_get_mana); MageValue::_vptrMap["manaBar"] = reinterpret_cast<void*>(&_vptr_wrap_Mage_manaBar); MageValue::_vptrMap["get_maxStamina"] = reinterpret_cast<void*>(&_vptr_wrap_Mage_get_maxStamina); MageValue::_vptrMap["get_stamina"] = reinterpret_cast<void*>(&_vptr_wrap_Mage_get_stamina); MageValue::_vptrMap["staminaBar"] = reinterpret_cast<void*>(&_vptr_wrap_Mage_staminaBar); MageValue::_vptrMap["statusBars"] = reinterpret_cast<void*>(&_vptr_wrap_Mage_statusBars); return true; }();
MageValue* Mage_new(MageValue* this__, std::string name) {
    auto this_ = this__;
    if (MageValue::_vptrMap.empty()) {
        MageValue::_vptrMap["get_maxHealth"] = reinterpret_cast<void*>(&_vptr_wrap_Mage_get_maxHealth);
        MageValue::_vptrMap["get_health"] = reinterpret_cast<void*>(&_vptr_wrap_Mage_get_health);
        MageValue::_vptrMap["healthBar"] = reinterpret_cast<void*>(&_vptr_wrap_Mage_healthBar);
        MageValue::_vptrMap["get_maxMana"] = reinterpret_cast<void*>(&_vptr_wrap_Mage_get_maxMana);
        MageValue::_vptrMap["get_mana"] = reinterpret_cast<void*>(&_vptr_wrap_Mage_get_mana);
        MageValue::_vptrMap["manaBar"] = reinterpret_cast<void*>(&_vptr_wrap_Mage_manaBar);
        MageValue::_vptrMap["get_maxStamina"] = reinterpret_cast<void*>(&_vptr_wrap_Mage_get_maxStamina);
        MageValue::_vptrMap["get_stamina"] = reinterpret_cast<void*>(&_vptr_wrap_Mage_get_stamina);
        MageValue::_vptrMap["staminaBar"] = reinterpret_cast<void*>(&_vptr_wrap_Mage_staminaBar);
        MageValue::_vptrMap["statusBars"] = reinterpret_cast<void*>(&_vptr_wrap_Mage_statusBars);
    }
    GameCharacter_new(this_, name);
    return this_;
}

int64_t Mage_get_maxMana(MageValue* this__) {
    auto this_ = this__;
    return 200LL;
}

int64_t Mage_get_maxHealth(MageValue* this__) {
    auto this_ = this__;
    return 60LL;
}

int main() {
    staticPrint(std::string("=== 复杂 OOP 边界测试 ===\n"));
    staticPrint(std::string("--- 1. 菱形继承 ---"));
    DiamondClassValue* diamond = DiamondClass_new(GC::allocateLocal(new DiamondClassValue()), std::string("DC"));
    staticPrint(dart_str(std::string("prefix: ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(diamond->getVptrMap()["get_prefix"]))(diamond))));
    staticPrint(dart_str(std::string("format: ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(diamond->getVptrMap()["format"]))(diamond, _box(std::string("hello"))))));
    staticPrint(dart_str(std::string("display: ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(diamond->getVptrMap()["display"]))(diamond, _box(std::string("world"))))));
    staticPrint(std::string("\n--- 2. StatefulMixin ---"));
    StatefulWidgetValue* widget = StatefulWidget_new(GC::allocateLocal(new StatefulWidgetValue()), std::string("btn1"));
    staticPrint(dart_str(std::string("initial: ")) + dart_str(widget));
    (reinterpret_cast<AnyGC*(*)(AnyGC*)>(widget->getVptrMap()["increment"]))(widget);
    (reinterpret_cast<AnyGC*(*)(AnyGC*)>(widget->getVptrMap()["increment"]))(widget);
    (reinterpret_cast<AnyGC*(*)(AnyGC*)>(widget->getVptrMap()["increment"]))(widget);
    staticPrint(dart_str(std::string("after 3 inc: ")) + dart_str(widget));
    (reinterpret_cast<AnyGC*(*)(AnyGC*)>(widget->getVptrMap()["decrement"]))(widget);
    staticPrint(dart_str(std::string("after 1 dec: ")) + dart_str(widget));
    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(widget->getVptrMap()["set_counter"]))(widget, _box(10LL));
    staticPrint(dart_str(std::string("after set 10: ")) + dart_str(widget));
    staticPrint(std::string("\n--- 3. 深层 mixin 链 ---"));
    DeepMixinClassValue* deep = DeepMixinClass_new(GC::allocateLocal(new DeepMixinClassValue()));
    staticPrint(dart_str(std::string("layer: ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(deep->getVptrMap()["layer"]))(deep))));
    staticPrint(dart_str(std::string("allLayers: ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(deep->getVptrMap()["allLayers"]))(deep))));
    staticPrint(std::string("\n--- 4. 泛型 mixin ---"));
    BoxValue<int64_t>* intBox = Box_new<int64_t>(GC::allocateLocal(new BoxValue<int64_t>()), 42LL);
    staticPrint(dart_str(std::string("intBox: ")) + dart_str(intBox));
    staticPrint(dart_str(std::string("describe: ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(intBox->getVptrMap()["describe"]))(intBox))));
    staticPrint(dart_str(std::string("mapValue: ")) + dart_str((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(intBox->getVptrMap()["mapValue"]))(intBox, _box(GC::allocateLocal(static_cast<TypeFunction1<int64_t, int64_t>*>(new ClosureEnv_2()))))));
    staticPrint(dart_str(std::string("test >10: ")) + dart_str(dynAs<bool>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(intBox->getVptrMap()["test"]))(intBox, _box(GC::allocateLocal(static_cast<TypeFunction1<bool, int64_t>*>(new ClosureEnv_3())))))));
    staticPrint(dart_str(std::string("test >100: ")) + dart_str(dynAs<bool>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(intBox->getVptrMap()["test"]))(intBox, _box(GC::allocateLocal(static_cast<TypeFunction1<bool, int64_t>*>(new ClosureEnv_4())))))));
    BoxValue<std::string>* strBox = Box_new<std::string>(GC::allocateLocal(new BoxValue<std::string>()), std::string("dart"));
    staticPrint(dart_str(std::string("strBox mapValue: ")) + dart_str((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(strBox->getVptrMap()["mapValue"]))(strBox, _box(GC::allocateLocal(static_cast<TypeFunction1<std::string, std::string>*>(new ClosureEnv_5()))))));
    staticPrint(std::string("\n--- 5. 抽象+mixin+implements ---"));
    TaggedResourceValue* res = TaggedResource_new(GC::allocateLocal(new TaggedResourceValue()), std::string("r1"), std::string("file"));
    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(res->getVptrMap()["tag"]))(res, _box(std::string("important")));
    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(res->getVptrMap()["tag"]))(res, _box(std::string("v2")));
    staticPrint(dart_str(std::string("describe: ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(res->getVptrMap()["describe"]))(res))));
    staticPrint(dart_str(std::string("id: ")) + dart_str(static_cast<ResourceValue*>(res)->id));
    staticPrint(dart_str(std::string("hasTag important: ")) + dart_str(dynAs<bool>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(res->getVptrMap()["hasTag"]))(res, _box(std::string("important"))))));
    staticPrint(dart_str(std::string("hasTag draft: ")) + dart_str(dynAs<bool>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(res->getVptrMap()["hasTag"]))(res, _box(std::string("draft"))))));
    staticPrint(std::string("\n--- 6. super 调用链 ---"));
    BaseProcessorValue* base = BaseProcessor_new(GC::allocateLocal(new BaseProcessorValue()));
    staticPrint(dart_str(std::string("base: ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(base->getVptrMap()["process"]))(base, _box(std::string("  hello  "))))) + dart_str(std::string(" (")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(base->getVptrMap()["get_processorName"]))(base))) + dart_str(std::string(")")));
    UpperProcessorValue* upper = UpperProcessor_new(GC::allocateLocal(new UpperProcessorValue()));
    staticPrint(dart_str(std::string("upper: ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(upper->getVptrMap()["process"]))(upper, _box(std::string("  hello  "))))) + dart_str(std::string(" (")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(upper->getVptrMap()["get_processorName"]))(upper))) + dart_str(std::string(")")));
    PrefixProcessorValue* prefix = PrefixProcessor_new(GC::allocateLocal(new PrefixProcessorValue()), std::string("PRE"));
    staticPrint(dart_str(std::string("prefix: ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(prefix->getVptrMap()["process"]))(prefix, _box(std::string("  hello  "))))) + dart_str(std::string(" (")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(prefix->getVptrMap()["get_processorName"]))(prefix))) + dart_str(std::string(")")));
    staticPrint(std::string("\n--- 7. mixin + operator ---"));
    AmountValue* a1 = Amount_new(GC::allocateLocal(new AmountValue()), 10LL);
    AmountValue* a2 = Amount_new(GC::allocateLocal(new AmountValue()), 5LL);
    staticPrint(dart_str(std::string("a1 + a2: ")) + dart_str(reinterpret_cast<AmountValue*>((reinterpret_cast<AnyGC*(*)(AnyGC*,AnyGC*)>(a1->getVptrMap()["+"]))(a1, _box(a2)))));
    staticPrint(dart_str(std::string("a1 - a2: ")) + dart_str(reinterpret_cast<AmountValue*>((reinterpret_cast<AnyGC*(*)(AnyGC*,AnyGC*)>(a1->getVptrMap()["-"]))(a1, _box(a2)))));
    staticPrint(dart_str(std::string("a1 < a2: ")) + dart_str(dynAs<bool>((reinterpret_cast<AnyGC*(*)(AnyGC*,AnyGC*)>(a1->getVptrMap()["<"]))(a1, _box(a2)))));
    staticPrint(dart_str(std::string("a1 > a2: ")) + dart_str(dynAs<bool>((reinterpret_cast<AnyGC*(*)(AnyGC*,AnyGC*)>(a1->getVptrMap()[">"]))(a1, _box(a2)))));
    staticPrint(dart_str(std::string("doubleValue: ")) + dart_str(dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(a1->getVptrMap()["doubleValue"]))(a1))));
    staticPrint(dart_str(std::string("addValues: ")) + dart_str(dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(a1->getVptrMap()["addValues"]))(a1, _box(3LL)))));
    staticPrint(std::string("\n--- 8. 多层继承+mixin ---"));
    CarValue* car = Car_new(GC::allocateLocal(new CarValue()), std::string("Toyota"), 2024LL, 4LL);
    staticPrint(dart_str(std::string("car: ")) + dart_str(car));
    (reinterpret_cast<AnyGC*(*)(AnyGC*)>(car->getVptrMap()["prettyPrint"]))(car);
    ElectricCarValue* ev = ElectricCar_new(GC::allocateLocal(new ElectricCarValue()), std::string("Tesla"), 2025LL, 4LL, 500LL);
    staticPrint(dart_str(std::string("ev: ")) + dart_str(ev));
    (reinterpret_cast<AnyGC*(*)(AnyGC*)>(ev->getVptrMap()["prettyPrint"]))(ev);
    staticPrint(std::string("\n--- 9. mixin on 约束 ---"));
    SegmentValue* seg = Segment_new(GC::allocateLocal(new SegmentValue()), 10.0);
    staticPrint(dart_str(std::string("seg: ")) + dart_str(seg));
    staticPrint(dart_str(std::string("scale(2): ")) + dart_str(dynAs<double>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(seg->getVptrMap()["scale"]))(seg, _box(2.0)))));
    WeightedSegmentValue* wseg = WeightedSegment_new(GC::allocateLocal(new WeightedSegmentValue()), 10.0, 0.5);
    staticPrint(dart_str(std::string("wseg: ")) + dart_str(wseg));
    staticPrint(dart_str(std::string("wseg.scale(3): ")) + dart_str(dynAs<double>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(wseg->getVptrMap()["scale"]))(wseg, _box(3.0)))));
    staticPrint(std::string("\n--- 10. 多 mixin 同名 getter ---"));
    MultiMixinEntityValue* entity = MultiMixinEntity_new(GC::allocateLocal(new MultiMixinEntityValue()));
    staticPrint(dart_str(std::string("label: ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(entity->getVptrMap()["get_label"]))(entity))));
    staticPrint(dart_str(std::string("greet: ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(entity->getVptrMap()["greet"]))(entity))));
    staticPrint(dart_str(std::string("info: ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(entity->getVptrMap()["info"]))(entity))));
    staticPrint(dart_str(std::string("fullInfo: ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(entity->getVptrMap()["fullInfo"]))(entity))));
    staticPrint(std::string("\n--- 11. 接口+mixin 覆盖 ---"));
    MultiEncoderValue* multi = MultiEncoder_new(GC::allocateLocal(new MultiEncoderValue()));
    staticPrint(dart_str(std::string("multi.encode: ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(multi->getVptrMap()["encode"]))(multi, _box(std::string("abc"))))));
    staticPrint(dart_str(std::string("multi.encodeAll: ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(multi->getVptrMap()["encodeAll"]))(multi, _box(std::string("xyz"))))));
    CustomEncoderValue* custom = CustomEncoder_new(GC::allocateLocal(new CustomEncoderValue()));
    staticPrint(dart_str(std::string("custom.encode: ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(custom->getVptrMap()["encode"]))(custom, _box(std::string("abc"))))));
    staticPrint(dart_str(std::string("custom.encodeAll: ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(custom->getVptrMap()["encodeAll"]))(custom, _box(std::string("xyz"))))));
    staticPrint(std::string("\n--- 12. 泛型继承链 ---"));
    ContainerValue<int64_t>* c1 = Container_new<int64_t>(GC::allocateLocal(new ContainerValue<int64_t>()), 42LL);
    staticPrint(dart_str(std::string("c1: ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(c1->getVptrMap()["describe"]))(c1))));
    LabeledContainerValue<std::string>* c2 = LabeledContainer_new<std::string>(GC::allocateLocal(new LabeledContainerValue<std::string>()), std::string("hello"), std::string("greeting"));
    staticPrint(dart_str(std::string("c2: ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(c2->getVptrMap()["describe"]))(c2))));
    PriorityContainerValue<double>* c3 = PriorityContainer_new<double>(GC::allocateLocal(new PriorityContainerValue<double>()), 3.14, std::string("pi"), 1LL);
    staticPrint(dart_str(std::string("c3: ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(c3->getVptrMap()["describe"]))(c3))));
    staticPrint(dart_str(std::string("c3.content: ")) + dart_str((reinterpret_cast<AnyGC*(*)(AnyGC*)>(c3->getVptrMap()["get_content"]))(c3)));
    staticPrint(std::string("\n--- 13. mixin 调用链 ---"));
    ChainClassValue* chain1 = ChainClass_new(GC::allocateLocal(new ChainClassValue()));
    staticPrint(dart_str(std::string("chain1.fullChain: ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(chain1->getVptrMap()["fullChain"]))(chain1))));
    staticPrint(dart_str(std::string("chain1.step3: ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(chain1->getVptrMap()["step3"]))(chain1))));
    ChainSubClassValue* chain2 = ChainSubClass_new(GC::allocateLocal(new ChainSubClassValue()));
    staticPrint(dart_str(std::string("chain2.fullChain: ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(chain2->getVptrMap()["fullChain"]))(chain2))));
    staticPrint(dart_str(std::string("chain2.step3: ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(chain2->getVptrMap()["step3"]))(chain2))));
    staticPrint(std::string("\n--- 14. 表达式树 ---"));
    BinaryExprValue* expr = BinaryExpr_new_add(NumberExpr_new(GC::allocateLocal(new NumberExprValue()), 3.0), BinaryExpr_new_mul(NumberExpr_new(GC::allocateLocal(new NumberExprValue()), 4.0), NumberExpr_new(GC::allocateLocal(new NumberExprValue()), 5.0)));
    staticPrint(dart_str(std::string("expr: ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(expr->getVptrMap()["display"]))(expr))));
    staticPrint(dart_str(std::string("result: ")) + dart_str(dynAs<double>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(expr->getVptrMap()["evaluate"]))(expr))));
    staticPrint(std::string("\n--- 15. 游戏角色 ---"));
    GameCharacterValue* hero = GameCharacter_new(GC::allocateLocal(new GameCharacterValue()), std::string("Hero"));
    staticPrint(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(hero->getVptrMap()["statusBars"]))(hero)));
    WarriorValue* warrior = Warrior_new(GC::allocateLocal(new WarriorValue()), std::string("Conan"));
    staticPrint(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(warrior->getVptrMap()["statusBars"]))(warrior)));
    MageValue* mage = Mage_new(GC::allocateLocal(new MageValue()), std::string("Gandalf"));
    staticPrint(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(mage->getVptrMap()["statusBars"]))(mage)));
    staticPrint(std::string("\n=== 所有复杂 OOP 测试通过 ✅ ==="));
    return 0;
}

AnyGC* DiamondClass_get_prefix(DiamondClassValue* this__) {
    auto this_ = this__;
    return _box(std::string("FMT"));
}

AnyGC* DiamondClass_format(DiamondClassValue* this__, std::string msg) {
    auto this_ = this__;
    return _box(dart_str(std::string("{")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_prefix"]))(this_))) + dart_str(std::string(": ")) + dart_str(msg) + dart_str(std::string("}")));
}

AnyGC* StatefulWidget_get_counter(StatefulWidgetValue* this__) {
    auto this_ = this__;
    return _box(this_->_counter);
}

void StatefulWidget_increment(StatefulWidgetValue* this__) {
    auto this_ = this__;
    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["set_counter"]))(this_, _box((dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_counter"]))(this_)) + 1LL)));
    return;
}

void StatefulWidget_decrement(StatefulWidgetValue* this__) {
    auto this_ = this__;
    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["set_counter"]))(this_, _box((dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_counter"]))(this_)) - 1LL)));
    return;
}

AnyGC* StatefulWidget_get_counterStatus(StatefulWidgetValue* this__) {
    auto this_ = this__;
    return _box(dart_str(std::string("count=")) + dart_str(dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_counter"]))(this_))));
}

void StatefulWidget_set_counter(StatefulWidgetValue* this__, AnyGC* value) {
    auto this_ = this__;
    auto _setter_value = dynAs<int64_t>(value);
    (this_->_counter = _setter_value);
    return;
}

AnyGC* DeepMixinClass_layer(DeepMixinClassValue* this__) {
    auto this_ = this__;
    return _box(std::string("C"));
}

AnyGC* DeepMixinClass_onlyA(DeepMixinClassValue* this__) {
    auto this_ = this__;
    return _box(std::string("onlyA"));
}

AnyGC* DeepMixinClass_onlyB(DeepMixinClassValue* this__) {
    auto this_ = this__;
    return _box(std::string("onlyB"));
}

AnyGC* DeepMixinClass_onlyC(DeepMixinClassValue* this__) {
    auto this_ = this__;
    return _box(std::string("onlyC"));
}

template<typename T>
T Box_get_value(BoxValue<T>* this__) {
    auto this_ = this__;
    return this_->value;
}

template<typename T, typename R>
AnyGC* Box_mapValue(BoxValue<T>* this__, TypeFunction1<R, T>* transform) {
    auto this_ = this__;
    return _box(transform->call(this_->value));
}

template<typename T>
AnyGC* Box_describe(BoxValue<T>* this__) {
    auto this_ = this__;
    return _box(dart_str(std::string("Mappable<")) + dart_str(std::string("TypeParameterType(_Box&Object&Mappable.T%)")) + dart_str(std::string(">(")) + dart_str(this_->value) + dart_str(std::string(")")));
}

template<typename T>
AnyGC* Box_test(BoxValue<T>* this__, TypeFunction1<bool, T>* predicate) {
    auto this_ = this__;
    return _box(predicate->call(this_->value));
}

std::string Resource_get_id(ResourceValue* this__) {
    auto this_ = this__;
    return "";
}

AnyGC* TaggedResource_get_id(TaggedResourceValue* this__) {
    auto this_ = this__;
    return nullptr;
}

void TaggedResource_tag(TaggedResourceValue* this__, std::string t) {
    auto this_ = this__;
    this_->_tags->add(t);
    return;
}

AnyGC* TaggedResource_get_allTags(TaggedResourceValue* this__) {
    auto this_ = this__;
    return _box(unmodifiable<std::string>(this_->_tags));
}

AnyGC* TaggedResource_hasTag(TaggedResourceValue* this__, std::string t) {
    auto this_ = this__;
    return _box(this_->_tags->contains(t));
}

int64_t Amount_get_numericValue(AmountValue* this__) {
    auto this_ = this__;
    return 0;
}

AnyGC* Amount_addValues(AmountValue* this__, int64_t other) {
    auto this_ = this__;
    return _box((this_->numericValue + other));
}

AnyGC* Amount_doubleValue(AmountValue* this__) {
    auto this_ = this__;
    return _box(dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["addValues"]))(this_, _box(this_->numericValue))));
}

void Car_prettyPrint(CarValue* this__) {
    auto this_ = this__;
    staticPrint(dart_str(std::string(">> ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["toPrettyString"]))(this_))));
    return;
}

void ElectricCar_prettyPrint(ElectricCarValue* this__) {
    auto this_ = this__;
    staticPrint(dart_str(std::string(">> ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["toPrettyString"]))(this_))));
    return;
}

AnyGC* Segment_scale(SegmentValue* this__, double factor) {
    auto this_ = this__;
    return _box((dynAs<double>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["measure"]))(this_)) * factor));
}

AnyGC* Segment_measureInfo(SegmentValue* this__) {
    auto this_ = this__;
    return _box(dart_str(std::string("measure=")) + dart_str(([&]() { std::ostringstream _ss; _ss << std::fixed << std::setprecision(1LL) << dynAs<double>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["measure"]))(this_)); return _ss.str(); })()));
}

AnyGC* WeightedSegment_scale(WeightedSegmentValue* this__, double factor) {
    auto this_ = this__;
    return _box((dynAs<double>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["measure"]))(this_)) * factor));
}

AnyGC* WeightedSegment_measureInfo(WeightedSegmentValue* this__) {
    auto this_ = this__;
    return _box(dart_str(std::string("measure=")) + dart_str(([&]() { std::ostringstream _ss; _ss << std::fixed << std::setprecision(1LL) << dynAs<double>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["measure"]))(this_)); return _ss.str(); })()));
}

AnyGC* MultiMixinEntity_greet(MultiMixinEntityValue* this__) {
    auto this_ = this__;
    return _box(dart_str(std::string("Hello from ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_label"]))(this_))));
}

AnyGC* MultiMixinEntity_info(MultiMixinEntityValue* this__) {
    auto this_ = this__;
    return _box(dart_str(std::string("Info: ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_label"]))(this_))));
}

AnyGC* MultiEncoder_encode(MultiEncoderValue* this__, std::string input) {
    auto this_ = this__;
    return _box(dart_str(std::string("hex(")) + dart_str(input) + dart_str(std::string(")")));
}

AnyGC* CustomEncoder_encodeAll(CustomEncoderValue* this__, std::string input) {
    auto this_ = this__;
    return _box(MultiEncoder_encodeAll(this_, input));
}

template<typename T>
AnyGC* LabeledContainer_get_content(LabeledContainerValue<T>* this__) {
    auto this_ = this__;
    return _box(Container_get_content<T>(static_cast<ContainerValue<T>*>(this_)));
}

template<typename T>
AnyGC* PriorityContainer_get_content(PriorityContainerValue<T>* this__) {
    auto this_ = this__;
    return _box(this_->item);
}

AnyGC* ChainClass_step2(ChainClassValue* this__) {
    auto this_ = this__;
    return _box(dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["step1"]))(this_))) + dart_str(std::string("->S2")));
}

AnyGC* ChainClass_step3(ChainClassValue* this__) {
    auto this_ = this__;
    return _box(dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["step2"]))(this_))) + dart_str(std::string("->S3")));
}

AnyGC* ChainClass_fullChain(ChainClassValue* this__) {
    auto this_ = this__;
    return _box(dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["step3"]))(this_))) + dart_str(std::string("->done")));
}

AnyGC* ChainSubClass_step1(ChainSubClassValue* this__) {
    auto this_ = this__;
    return _box(std::string("X1"));
}

AnyGC* ChainSubClass_step3(ChainSubClassValue* this__) {
    auto this_ = this__;
    return _box(dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["step2"]))(this_))) + dart_str(std::string("->S3")));
}

AnyGC* ChainSubClass_fullChain(ChainSubClassValue* this__) {
    auto this_ = this__;
    return _box(dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["step3"]))(this_))) + dart_str(std::string("->done")));
}

AnyGC* GameCharacter_get_maxHealth(GameCharacterValue* this__) {
    auto this_ = this__;
    return _box(100LL);
}

AnyGC* GameCharacter_get_health(GameCharacterValue* this__) {
    auto this_ = this__;
    return _box(dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_maxHealth"]))(this_)));
}

AnyGC* GameCharacter_healthBar(GameCharacterValue* this__) {
    auto this_ = this__;
    return _box(dart_str(std::string("HP:")) + dart_str(dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_health"]))(this_))) + dart_str(std::string("/")) + dart_str(dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_maxHealth"]))(this_))));
}

AnyGC* GameCharacter_get_maxMana(GameCharacterValue* this__) {
    auto this_ = this__;
    return _box(50LL);
}

AnyGC* GameCharacter_get_mana(GameCharacterValue* this__) {
    auto this_ = this__;
    return _box(dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_maxMana"]))(this_)));
}

AnyGC* GameCharacter_manaBar(GameCharacterValue* this__) {
    auto this_ = this__;
    return _box(dart_str(std::string("MP:")) + dart_str(dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_mana"]))(this_))) + dart_str(std::string("/")) + dart_str(dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_maxMana"]))(this_))));
}

AnyGC* GameCharacter_get_maxStamina(GameCharacterValue* this__) {
    auto this_ = this__;
    return _box(80LL);
}

AnyGC* GameCharacter_get_stamina(GameCharacterValue* this__) {
    auto this_ = this__;
    return _box(dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_maxStamina"]))(this_)));
}

AnyGC* GameCharacter_staminaBar(GameCharacterValue* this__) {
    auto this_ = this__;
    return _box(dart_str(std::string("SP:")) + dart_str(dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_stamina"]))(this_))) + dart_str(std::string("/")) + dart_str(dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_maxStamina"]))(this_))));
}

AnyGC* Warrior_get_health(WarriorValue* this__) {
    auto this_ = this__;
    return _box(dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_maxHealth"]))(this_)));
}

AnyGC* Warrior_healthBar(WarriorValue* this__) {
    auto this_ = this__;
    return _box(dart_str(std::string("HP:")) + dart_str(dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_health"]))(this_))) + dart_str(std::string("/")) + dart_str(dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_maxHealth"]))(this_))));
}

AnyGC* Warrior_get_maxMana(WarriorValue* this__) {
    auto this_ = this__;
    return _box(50LL);
}

AnyGC* Warrior_get_mana(WarriorValue* this__) {
    auto this_ = this__;
    return _box(dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_maxMana"]))(this_)));
}

AnyGC* Warrior_manaBar(WarriorValue* this__) {
    auto this_ = this__;
    return _box(dart_str(std::string("MP:")) + dart_str(dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_mana"]))(this_))) + dart_str(std::string("/")) + dart_str(dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_maxMana"]))(this_))));
}

AnyGC* Warrior_get_stamina(WarriorValue* this__) {
    auto this_ = this__;
    return _box(dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_maxStamina"]))(this_)));
}

AnyGC* Warrior_staminaBar(WarriorValue* this__) {
    auto this_ = this__;
    return _box(dart_str(std::string("SP:")) + dart_str(dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_stamina"]))(this_))) + dart_str(std::string("/")) + dart_str(dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_maxStamina"]))(this_))));
}

AnyGC* Warrior_statusBars(WarriorValue* this__) {
    auto this_ = this__;
    return _box(GameCharacter_statusBars(this_));
}

AnyGC* Mage_get_health(MageValue* this__) {
    auto this_ = this__;
    return _box(dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_maxHealth"]))(this_)));
}

AnyGC* Mage_healthBar(MageValue* this__) {
    auto this_ = this__;
    return _box(dart_str(std::string("HP:")) + dart_str(dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_health"]))(this_))) + dart_str(std::string("/")) + dart_str(dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_maxHealth"]))(this_))));
}

AnyGC* Mage_get_mana(MageValue* this__) {
    auto this_ = this__;
    return _box(dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_maxMana"]))(this_)));
}

AnyGC* Mage_manaBar(MageValue* this__) {
    auto this_ = this__;
    return _box(dart_str(std::string("MP:")) + dart_str(dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_mana"]))(this_))) + dart_str(std::string("/")) + dart_str(dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_maxMana"]))(this_))));
}

AnyGC* Mage_get_maxStamina(MageValue* this__) {
    auto this_ = this__;
    return _box(80LL);
}

AnyGC* Mage_get_stamina(MageValue* this__) {
    auto this_ = this__;
    return _box(dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_maxStamina"]))(this_)));
}

AnyGC* Mage_staminaBar(MageValue* this__) {
    auto this_ = this__;
    return _box(dart_str(std::string("SP:")) + dart_str(dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_stamina"]))(this_))) + dart_str(std::string("/")) + dart_str(dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_maxStamina"]))(this_))));
}

AnyGC* Mage_statusBars(MageValue* this__) {
    auto this_ = this__;
    return _box(GameCharacter_statusBars(this_));
}

