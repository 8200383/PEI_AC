# Relatório de PEI

## Identificação das propriedades do XSD

### Namespaces
No seguinte excerto de código deparamo-nos com o targetNamespace cuja declaração tem como significado que todos 
os elementos (filhos do root) do documento pertencem ao mesmo namespace, é normal a utilização do atributo `elementFormDefault`
na definição do XSD com a finalidade de indicar que todos os elementos são qualified ou seja que estão associados ao target 
namespace.

No excerto de código a seguir descreve o namespace por defeito para indicar que todos os elementos utilizados neste documento 
estão declarados no namespace.
```xml

<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema"
           targetNamespace="https://www.w3schools.com/ReservationSchema"
           elementFormDefault="qualified"/>
```

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<Reservation xmlns="https://www.w3schools.com/ReservationSchema">
</Reservation>
```

### Elementos do XSD
Este excerto de código permite a definição do elemento "Reservation" com os seus respetivos 
elementos `Family` e `Days` e os seus respetivos tipos.
```xml

<xs:element name="Reservation">
    <xs:complexType>
        <xs:sequence>
            <xs:element name="Family" type="rs:FamilyType"/>
            <xs:element name="Days" type="rs:DaysType"/>
        </xs:sequence>
    </xs:complexType>
</xs:element>
```

```xml

<Reservation>
    <Family>
        <!--1 to 7 repetitions:-->
        <Member>
            <Name>string</Name>
            <Country>string</Country>
            <City>string</City>
            <Birthday>2008-09-29</Birthday>
        </Member>
    </Family>
    <Days>
        <!--1 to 5 repetitions:-->
        <Day>2021-12-23</Day>
    </Days>
</Reservation>
```

### Tipos Complexos

#### FamilyType
O seguinte excerto de código permite a definição de uma sequência com o valor máximo de 7 membros.
```xml

<xs:complexType name="FamilyType">
    <xs:sequence>
        <xs:element name="Member" type="rs:MemberType" maxOccurs="7"/>
    </xs:sequence>
</xs:complexType>
```

#### MemberType
O seguinte excerto de código permite definir o tipo complexo "MemberType" que constituí uma sequência de 
strings tais como: `Name`, `Country`, `City`, `Birthday`.
```xml

<xs:complexType name="MemberType">
    <xs:sequence>
        <xs:element name="Name" type="xs:string"/>
        <xs:element name="Country" type="xs:string"/>
        <xs:element name="City" type="xs:string"/>
        <xs:element name="Birthday" type="xs:date"/>
    </xs:sequence>
</xs:complexType>
```

#### DaysType
O seguinte excerto de codigo permite definir uma sequência máxima de datas até 5 dias.
```xml

<xs:complexType name="DaysType">
    <xs:sequence>
        <xs:element name="Day" type="rs:DayType" maxOccurs="5"/>
    </xs:sequence>
</xs:complexType>
```

### Tipos Simples

#### DayType
O seguinte excerto de codigo define um tipo simples chamado "DayType" com uma restrição. Este deve ter
exatamente 10 caracteres, a data deve estar compreendida entre "2021-10-16" e "2021-12-25".
```xml

<xs:simpleType name="DayType">
    <xs:restriction base="xs:date">
        <xs:minInclusive value="2021-10-16"/>
        <xs:maxInclusive value="2021-12-25"/>
        <xs:pattern value=".{10}"/>
    </xs:restriction>
</xs:simpleType>
```