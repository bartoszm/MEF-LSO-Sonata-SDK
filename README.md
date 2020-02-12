# MEF-LSO-Sonata-SDK (R4)

This repository contains the MEF LSO Sonata SDK.

This SDK release aligns the API schemas and definitions for Serviceability (Address Validation, Site Queries, Product Offering Qualification) and Product Inventory to the latest versions of MEF 79 and MEF 81 Draft Standards. In addition, the API schemas and definitions for Product Order are aligned with the new version of other Sonata APIs. The latest versions of MEF 79 and MEF 81 Draft Standards are included.

MEF LSO Sonata SDK includes API definitions for the following functional areas:

*  Serviceability (Address, Service Site, and Product Offering Qualification Management)
*  Product Quote
*  Product Order
*  Product Inventory

It also holds Payload Descriptions for the following structures that are used with these APIs
*  JSON representations for Product Spec descriptions (initially for MEF Access E-Line services)
*  JSON representations for the UNI attributes (sourced from MEF 57.1)

The MEF LSO Sonata SDK is released under the Apache 2.0 license.

## Maturity Level
The API files contained in this SDK are evolving and subject to change.  They are based on documents that are either ratified standards, or draft standards that have not yet completed the review cycles and approvals necessary to achieve the status as a MEF standard.  MEF is making these publicly available at this time to invite wider industry review.

## Contents

This SDK contains the following items:

*  COPYRIGHT - Copyright 2019 MEF Forum
*  LICENSE - Contains a copy of the Apache 2.0 license
*  README - This file
*  payload_description - Common descriptors are found in this directory
	*  ProductSpecDescription – Contains reference JSON schemas for product specification description.
*  api - Definitions of the API are found in this directory
	*  Inventory - Contains the API definitions necessary for inter-carrier retrieval  of  Product  Inventory
	*  Quote - Contains the API definitions for inter-carrier service quotation capability
	*  Serviceability - Contains the API definitions that allow the Service Provider, or Buyer to:
		* Retrieve Address information including exact formats for Addresses known to the Seller
		* Retrieve Service Site information including exact formats for Service Sites known to the Seller
		* Determine whether it is feasible for the Seller to deliver a particular Product with a given configuration to a particular geographic location if applicable.
	*  ProductOrder - Contains the API definitions for inter-carrier service ordering capability.
*  documentation - This contains the draft standards of the Business Requirements and Use Cases for
	* Address, Service Site, and Product Offering Qualification Management (MEF 79 Draft (R3))
	* Product Order Management (MEF 80 Draft (R2))
	* Product Inventory Management (MEF 81 Draft (R3))

All superseded files can be found in the Git history, if needed.

## Precedents
Any developer intending to use the materials in this repository should first thoroughly read, review and understand the following materials:
*  [MEF 55: Lifecycle Service Orchestration (LSO): Reference Architecture and Framework](documentation/MEF%2055%20-%20LSO%20Reference%20Architecture%20and%20Framework.pdf) This document is a ratified MEF standard.
*  [MEF 55.0.1: Amendment to MEF 55: Operational Threads](documentation/MEF%2055.0.1%20-%20Operational%20Threads.pdf) This document is a ratified MEF standard.
*  [MEF 55.0.2: Amendment to MEF 55: TOSCA Services Templates](documentation/MEF%2055.0.2%20-%20TOSCA%20Service%20Templates.pdf) This document is a ratified MEF standard.
*  [MEF 50.1: MEF Services Lifecycle Process Flows](documentation/MEF%2050.1%20-%20MEF%20Services%20Lifecycle%20Process%20Flows.pdf) This document is a ratified MEF standard.
*  [MEF 79 Draft (R3): Address, Service Site, and Product Offering Qualification Management](documentation/MEF%2079%20Draft%20(R3)%20-%20Address%2C%20Service%20Site%2C%20and%20Product%20Offering%20Qualification%20Management.pdf)
*  [MEF 80 Draft (R2): Quote Management](documentation/MEF%2080%20Draft%20(R2)%20-%20Quote%20Management.pdf)
*  [MEF 81 Draft (R3): Product Inventory Management](documentation/MEF%2081%20Draft%20(R3)%20-%20Product%20Inventory%20Management.pdf)
*  [MEF 57.1: Ethernet Ordering Technical Standard - Business Requirements and Use Cases](documentation/MEF%2057.1%20-%20Ethernet%20Ordering%20Technical%20Specification%20-%20Business%20Requirements%20and%20Use%20Cases.pdf) This document is a ratified MEF standard.

## Tool support

MEF provides a convenient mechanism to automatically generate code bindings for Sonata POQ. The tool is containerized thus can be easily used at any machine with support for docker-based containerization.

### Build the image from definition 
The docker image use a [simple tool](https://github.com/bartoszm/codegen-wrapper) that in essence is an openAPI codegen with extensions that allow user to dynamically binding of API and product spec definitions.
First step in the process is building an image from definition   

```
docker image build --tag codegen .
```

### Generate code integrated spec

The tool can generate to any output format supported by [openAPI-generator](https://openapi-generator.tech/docs/generators) project. The command syntax is following:
```
docker run --rm -it -v <your-output>:/opt/MEF/out codegen generate -c <codegen-config> -i ./api/<api-definition> -p payload_descriptions/ProductSpecDescription/<product-spec>
```
and the details for `generate` command can be displayed using:
```
docker run --rm -it -v out:/opt/MEF/out codegen help generate
```
which are:
```
NAME
        openapi-generator-wrapper-cli generate - Generate code using
        configuration.

SYNOPSIS
        openapi-generator-wrapper-cli generate
                (-c <configuration file> | --config <configuration file>)
                (-i <spec file> | --input-spec <spec file>)
                [(-m <model to be augmented> | -model-name <model to be augmented>)]
                [(-p <product specifications> | --product-spec <product specifications>)...]

OPTIONS
        -c <configuration file>, --config <configuration file>
            Path to configuration file configuration file. It can be json or
            yaml.If file is json, the content should have the format
            {"optionKey":"optionValue", "optionKey1":"optionValue1"...}.If file
            is yaml, the content should have the format optionKey:
            optionValueSupported options can be different for each language. Run
            config-help -g {generator name} command for language specific config
            options.

        -i <spec file>, --input-spec <spec file>
            location of the OpenAPI spec, as URL or file (required)

        -m <model to be augmented>, -model-name <model to be augmented>
            Model which will be hosting product specific extensions (E.g.
            ProductCharacteristics)

        -p <product specifications>, --product-spec <product specifications>
            sets of product specification you would like to integrate
```

The tool offers three example configurations for spring server, python client, and aggregated open API definition.
So if you want to generate spring server side code binding for Product Offering Qualification management API together with all product specs available you can use following command:
```
docker run --rm -it -v out:/opt/MEF/out codegen generate -c configurations/spring-server-example.yaml -i ./api/Serviceability/MEF_api_productOfferingQualificationManagement_3.0.1.yaml -p payload_descriptions/ProductSpecDescription/MEF_UNISpec_v3.json -p 
payload_descriptions/ProductSpecDescription/MEF_ELineSpec_v3.json
```

If you prefer you can attach to docker CLI and go in interactive mode:
```
docker run --rm -it -v out:/opt/MEF/out --entrypoint /bin/bash codegen
```

And then to replicate above codegen use:
```
root@3a2dfb6eef20:/opt/MEF# java -jar wrapper.jar generate -c configurations/spring-server-example.yaml -i ./api/Serviceability/MEF_api_productOfferingQualificationManagement_3.0.1.yaml -p payload_descriptions/ProductSpecDescription/MEF_UNISpec_v3.json -p payload_descriptions/ProductSpecDescription/MEF_ELineSpec_v3.json
```


## Reference Implementations

**1) LSO Sonata APIs (older version) implementation on Buyer side - contributed by Amdocs**

   The example implementation of MEF LSO Sonata APIs on Buyer side provided by Amdocs. This example code is part of the solution between a Tier1 North American operator, Amdocs and a UK provider that was put into production in April 2019 to enable the automated ordering of Ethernet services.
   
   This LSO Sonata reference implementation is available on GitHub for MEF Members:

   https://github.com/MEF-GIT/Example-LSO-Sonata-Buyer-Implementation
   
   **NOTE:** If you are a MEF Member, please update your MEF wiki profile with your GitHub account name. Access to this repository is periodically updated with provided GitHub accounts. Additionally contact the [LSO Developer Community Manager](mailto:community_manager@mef.net) to request the immediate access.
   
   **NOTE:** This example LSO Sonata implementation does not provide an executable or runnable project and it is based on the older APIs version published in the "2018-dev-preview" release of the LSO Sonata SDK which is available here:
   https://github.com/MEF-GIT/MEF-LSO-Sonata-SDK/releases/tag/2018-dev-preview

## Questions and Feedback
Questions and Feedback should be directed to LSO-Sonata@mef.net.  All artifacts included in this repository have line numbers.  When referring to specific content in any of these artifacts, please quote the line numbers to which you are referring.

# Disclaimer & Copyright

The information in this publication is freely available for reproduction and use by any recipient and is believed to be accurate as of its publication date. Such information is subject to change without notice and MEF Forum (MEF) is not responsible for any errors. MEF does not assume responsibility to update or correct any information in this publication. No representation or warranty, expressed or implied, is made by MEF concerning the completeness, accuracy, or applicability of any information contained herein and no liability of any kind shall be assumed by MEF as a result of reliance upon such information.

The information contained herein is intended to be used without modification by the recipient or user of this document. MEF is not responsible or liable for any modifications to this document made by any other party.

The receipt or any use of this document or its contents does not in any way create, by implication or otherwise:

(a) any express or implied license or right to or under any patent, copyright, trademark or trade secret rights held or claimed by any MEF member which are or may be associated with the ideas, techniques, concepts or expressions contained herein; nor

(b) any warranty or representation that any MEF member will announce any product(s) and/or service(s) related thereto, or if such announcements are made, that such announced product(s) and/or service(s) embody any or all of the ideas, technologies, or concepts contained herein; nor

(c) any form of relationship between any MEF member and the recipient or user of this document.

Implementation or use of specific MEF standards, specifications, or recommendations will be voluntary, and no Member shall be obliged to implement them by virtue of participation in MEF Forum. MEF is a non-profit international organization to enable the development and worldwide adoption of agile, assured and orchestrated network services. MEF does not, expressly or otherwise, endorse or promote any specific products or services.

© MEF Forum 2019. All Rights Reserved.
