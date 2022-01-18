# Relatório de PEI

## Estrutura do projeto
- `/data`: Base de dados
- `/migration`: Script de migração
- `/mongo`: Query's
- `/postman`: Coleção de endpoints
- `/restxq`: Rest API
- `/xml`: Exemplos de XML
- `/xsd`: XSD Schemas

## Links
[Mongo Charts](google.com)

## Contextualização e Caracterização do caso de estudo
No âmbito da unidade curricular `Processamento Estruturado de Informação` para efeitos de avaliação contínua realizámos 
um trabalho prático com a finalidade de fornecer uma REST API ao "Pai Natal" de forma a facilitar a informação
necessária para a realização de agendamentos das famílias.

Sabemos ainda que o "Pai Natal" decidiu disponibilizar visitas à sua oficina 100 dias antes do natal porém, a demanda é 
imensa fazendo com que o "Pai Natal" desejasse tornar o processo de agendamento o mais justo e eficaz possível, para 
satisfazer esta necessidade foi elaborada uma restrição com um número máximo de 5.000 famílias sendo apenas possível a
visita de 50 famílias por dia.

Assim, nós o grupo nº1, os entusiastas da programação, decidiram ajudar o "Pai Natal" criando uma `API`
com recurso a tecnologias como: `BaseX`, `MongoDB`, `Postman` e linguagens: `XQuery`, `XPath`, `Js`, `Py`.

Todos tem uma API incluíndo o Pai Natal!


## Abordagem do problema
Conforme o enunciado nos indica para efetuar uma reserva é necessário explicitar as datas de preferência da família 
e os respetivos elemetos que constituem o agregado familiar até 7 membros, ou seja cada elemento da família deve
introduzir o seu `Name`, `Country`, `City` e `Birthday`.

De forma a agilizar o processo de agendamento das visitas à oficina do "Pai Natal", desenvolve-mos uma REST API em BaseX
com vários endpoints que permitem de forma fácil adicionar e remover reservas bem como verificar a disponibilidade entre
duas datas.

Esta REST API consome um ficheiro XML que posteriormente é validado contra um ficheiro XSD Schema e mais tarde estes dados
são armazenados na base de dados do `BaseX` e no final é devolvido o id da reserva autogerado e único.

Para complementar desenvolve-mos também um dashboard analítico com recurso ao serviço `Mongo Charts` de forma a promover 
uma melhor visualização dos dados das reservas, estas ínclui: 
- `📊 Average of persons per day`
- `📊 Number of cancellations per day`
- `📊 Percentage of occupation per day`
- `📊 Total bookings country`
- `📊 Total bookings per city`
- `📊 Sum of bookings until today`
- `📊 Total of Families per day`

Foi também desenvolvido um script de migração em linguagem `Python` que agiliza o processo de migração entre a API do 
`BaseX` e o `MongoDB`.

## Identificação das propriedades do XSD

### Namespaces
No seguinte excerto de código declaramos o `targetNamespace` cuja declaração tem como significado que todos 
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
Este excerto de código permite a definição do elemento `Reservation` com os seus respetivos 
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
O seguinte excerto de código permite definir o tipo complexo `MemberType` que constituí uma sequência de 
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
O seguinte excerto de codigo define um tipo simples chamado `DayType` com uma restrição. Este deve ter
exatamente 10 caracteres, a data deve estar compreendida entre `2021-10-16` e `2021-12-25`.
```xml

<xs:simpleType name="DayType">
    <xs:restriction base="xs:date">
        <xs:minInclusive value="2021-10-16"/>
        <xs:maxInclusive value="2021-12-25"/>
        <xs:pattern value=".{10}"/>
    </xs:restriction>
</xs:simpleType>
```