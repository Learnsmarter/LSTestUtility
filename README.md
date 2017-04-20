# Learnsarter Test Utility
Here we have provided a basic testing utility for external/local customizations to Learnsmarter. This testing utility makes it simple to create data for your unit tests while providing options for including required additional data with minimal modifications to the majority of the code.

## Table of Contents
* [Compatibility](#compatibility)
* [Installation](#installation)
* [Usage](#usage)
* [Customization Support](#customization)
* [Current Object Support](#objects)

<a name="compatibility"></a>
## Compatibility
The following version has been tested. Previous versions may still work. Engage is not supported.
* Learnsmarter Core 2.70

<a name="installation"></a>
## Installation
To install the test utility, upload the LSTestUtils apex class to your org. The LSTestUtilsTest class is not required but is useful for ensuring the test utility is in working order.

<a name="usage"></a>
## Usage
Inside your unit tests, use one of the many static methods defined in the LSTestUtils class for creating your desired Learnsmarter object.

Please note that you only need to request the object that you desire and do not need to request for parent objects as they will be created for you automatically.

For example, creating registrations is as easy as doing the following:

```java
lsc__booking__c[] bookings = LSTestUtils.createBookings(5);
```

The test utility does not insert the final record. This will give you the opportunity to make any changes prior to insertion. Your final product will look something like:

```java
lsc__booking__c[] bookings = LSTestUtils.createBookings(5);
insert bookings;
```

This will create 5 registrations (which we refer to as bookings in code), and the subsequent required records related to it.

<a name="customization"></a>
## Customization Support

If you have customizations that easily cause unit tests to fail, you can use the `afterPrepare()` method location at the top of the class to specify what changes to records you wish to make before they are inserted. This would be useful in the case where you are simply creating registrations but want to ensure you have the correct fields set on the Account to pass a validation rule for instance.

The most suitable solution to this is to create a separate helper class and refer to that inside the `afterPrepare()` method but you can also write the code directly inside the method.

The idea of this method is to ensure that the least amount of code inside the class is modified. This makes it much easier to upgrade the class when future versions are released.

In the below example, if you imagine that the organization requires the account to have the shipping address set, then the `afterPrepare()` method would modified to include the following:

```java
public static void afterPrepare(SObject obj) {

  // If the object type is Account
  if ( obj.getSObjectType() == Account.SObjectType ) {
    Account acc = (Account)obj;
    
    // Set shipping address
    acc.ShippingStreet = '44 Shirley Ave.';
    acc.ShippingCity = 'West Chicago';
    acc.ShippingState = 'IL';
    acc.ShippingPostalCode = 60185';
    acc.ShippingCountry = 'US';
  }
  
  // All done - nothing to return
}
```

<a name="objects"></a>
## Current Object Support
This test utility currently supports the following objects. Support for more objects will be included as demand for the test utility increases.

* Account
* Contact
* Subject area
* Course
* Location
* Venue
* Scheduled Course
* Registration
