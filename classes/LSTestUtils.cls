/**
 *
 * MIT License
 *
 * Copyright (c) 2017 Learnsmarter Apps Ltd
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 *
 * ******************************************************************************
 *
 * Basic test utility class for Learnsmarter extensions
 *
 * Each method will create the parent objects automatically before preparing the desired objects. For example,
 * when creating registrations, the parent scheduled course, course, course area, venue, location,
 * contact and accounts are created and set automatically.
 *
 * Each method will return the objects prior to insertion. You must insert the objects once returned.
 * This will allow you to make any data changes as necessary.
 *
 * @modified	: 2017-04-20 [Learnsmarter Only]
 *
 */

public with sharing class LSTestUtils {

	/**
	 * Empty class by default. This class is called after every object
	 * preparation. Write code in here to workaround customizations or include
	 * extra data fields.
	 *
	 * This method should prevent the need to modify the rest of the class for
	 * data values.
	 */
	public static void afterPrepare(SObject obj) {
		/*
		 * if ( obj.getSObjectType() == Account.SObjectType ) {
		 * 		Account example = (Account)obj;
		 * 		example.CustomField__c = 'Hello world';
		 * }
		 *
		 */
	}



	/**
	 * Prepare a list of accounts for insert
	 * @return list of accounts
	 */
	public static Account[] createAccounts(Integer num) {
		Account[] rsAccounts = new Account[]{};

		for ( Integer i=0; i<num; i++ ) {
			rsAccounts.add(new Account(
					Name = 'Test Account ' + i
			));

			afterPrepare(rsAccounts[i]);
		}

		return rsAccounts;
	}

	/**
	 * Prepare a list of contacts for insert
	 * @return list of contacts
	 */
	public static Contact[] createContacts(Integer num) {
		return createContacts(num, null);
	}
	public static Contact[] createContacts(Integer num, Id accountId) {

		// Create account if not set
		if ( accountId == null ) {
			Account rsAccount = createAccounts(1)[0];
			insert rsAccount;
			accountId = rsAccount.Id;
		}

		Contact[] rsContacts = new Contact[]{};

		for ( Integer i=0; i<num; i++ ) {
			rsContacts.add(new Contact(
					FirstName = 'Test ' + i,
					LastName = 'Test ' + i,
					Email = 'test' + i + '@b.c',
					AccountId = accountId
			));

			afterPrepare(rsContacts[i]);
		}

		return rsContacts;
	}




	/**
	 * Prepare a list of subject areas for insert
	 * @param number of subject areas to create
	 * @return list of subject areas
	 */
	public static lsc__coursearea__c[] createCourseAreas(Integer num) {
		lsc__coursearea__c[] courseAreas = new lsc__coursearea__c[]{};

		for ( Integer i=0; i<num; i++ ) {
			courseAreas.add(new lsc__coursearea__c(
					Name = 'Course ' + i
			));

			afterPrepare(courseAreas[i]);
		}

		return courseAreas;
	}


	/**
	 * Prepare a list of courses for insert
	 * @param number of courses to create
	 * @param parent subject area (optional)
	 * @return list of courses
	 */
	public static lsc__course__c[] createCourses(Integer num) {
		return createCourses(num, null);
	}
	public static lsc__course__c[] createCourses(Integer num, Id courseAreaId){
		lsc__course__c[] courses = new lsc__course__c[]{};

		// Create course area if not set
		if ( courseAreaId == null ) {
			lsc__coursearea__c courseArea = createCourseAreas(1)[0];
			insert courseArea;
			courseAreaId = courseArea.Id;
		}

		for ( Integer i=0; i<num; i++ ) {
			courses.add(new lsc__course__c(
					Name = 'Course ' + i,
					lsc__CourseArea__c = courseAreaId,
					lsc__IsActive__c = true,
					lsc__IsVisible__c = true
			));

			afterPrepare(courses[i]);
		}

		return courses;
	}

	/**
	 * Prepare a list of locations for insert
	 * @param number of locations to create
	 * @return list of locations
	 */
	public static lsc__location__c[] createLocations(Integer num) {
		lsc__location__c[] locations = new lsc__location__c[]{};

		for ( Integer i=0; i<num; i++ ) {
			locations.add(new lsc__location__c(
					Name = 'Location ' + i
			));

			afterPrepare(locations[i]);
		}

		return locations;
	}

	/**
	 * Prepare a list of venues for insert
	 * @param number of venues to create
	 * @param parent location (optional)
	 * @return list of venues
	 */
	public static lsc__venue__c[] createVenues(Integer num) {
		return createVenues(num, null);
	}
	public static lsc__venue__c[] createVenues(Integer num, Id locationId) {
		lsc__venue__c[] venues = new lsc__venue__c[]{};

		if ( locationId == null ) {
			lsc__location__c location = createLocations(1)[0];
			insert location;
			locationId = location.Id;
		}

		for ( Integer i=0; i<num; i++ ) {
			venues.add(new lsc__venue__c(
					Name = 'Venue ' + i,
					lsc__Location__c = locationId,
					lsc__TaxRuleBasis__c = 'VENUE_LOCATION'
			));

			afterPrepare(venues[i]);
		}

		return venues;
	}



	/**
	 * Prepare a list of scheduled courses for insert
	 * @param number of scheduled courses to create
	 * @param parent course(optional)
	 * @return list of scheduled courses
	 */
	public static lsc__event__c[] createEvents(Integer num) {
		return createEvents(num, null);
	}
	public static lsc__event__c[] createEvents(Integer num, Id courseId) {
		lsc__event__c[] events = new lsc__event__c[]{};

		// Create course if not set
		if ( courseId == null ) {
			lsc__course__c course = createCourses(1)[0];
			insert course;
			courseId = course.Id;
		}

		lsc__venue__c venue = createVenues(1)[0];
		insert venue;
		Id venueId = venue.Id;

		for ( Integer i=0; i<num; i++ ) {
			events.add(new lsc__event__c(
					lsc__Course__c = courseId,
					lsc__StartDateTime__c = DateTime.now().addDays(5),
					lsc__EndDateTime__c = DateTime.now().addDays(6),
					lsc__EventStatusID__c = 1,
					lsc__EventType__c = 'Public',
					lsc__MaxPlaces__c = 100,
					lsc__PlacesLeft__c = 100,
					lsc__SellingPrice__c = 100.00,
					lsc__IsPublished__c = true,
					lsc__Venue__c = venueId,
					lsc__IsVisible__c = true,
					lsc__TaxRuleBasis__c = 'VENUE_LOCATION'
			));

			afterPrepare(events[i]);
		}

		return events;
	}



	/**
	 * Prepare a list of registrations for insert
	 * @param number of registrations to create
	 * @param parent scheduled course(optional)
	 * @return list of scheduled courses
	 */
	public static lsc__booking__c[] createBookings(Integer num) {
		return createBookings(num, null);
	}
	public static lsc__booking__c[] createBookings(Integer num, Id eventId) {
		lsc__booking__c[] bookings = new lsc__booking__c[]{};

		// Create scheduled course if not set
		if ( eventId == null ) {
			lsc__event__c rsEvent = createEvents(1)[0];
			insert rsEvent;
			eventId = rsEvent.Id;
		}

		Contact primaryContact = createContacts(1)[0];
		insert primaryContact;

		for ( Integer i=0; i<num; i++ ) {
			bookings.add(new lsc__booking__c(
					lsc__Event__c = eventId,
					lsc__BookingStatusID__c = 2,
					lsc__PlacesRequired__c = 2,
					lsc__BookingType__c = 'group',
					lsc__BookingSaved__c = true,
					lsc__LeadContact__c = primaryContact.Id,
					lsc__Account__c = primaryContact.AccountId,
					lsc__BookingCost__c = 100.00,
					lsc__DiscountAmount__c = 0.00,
					lsc__TotalTax__c = 20.00,
					lsc__TotalCost__c = 120.00,
					lsc__AllocatedCount__c = 0,
					lsc__OrderNumber__c = '12345'
			));

			afterPrepare(bookings[i]);
		}

		return bookings;
	}

}
