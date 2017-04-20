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
 * This class is used to test the test utility.
 *
 * Because the test utility class is a test class itself, if you wish to see coverage
 * data you must comment out the @isTest annotation from LSTestUtils.
 *
 * This test class is not required but is useful for ensuring the test utility is
 * working as expected.
 *
 * @modified	: 2017-04-20 [Learnsmarter Only]
 *
 */

@isTest
public with sharing class LSTestUtilTest {

	public static testMethod void test_createBookings() {
		Test.startTest();

		lsc__booking__c[] rsBookings = LSTestUtil.createBookings(5);
		insert rsBookings;

		Test.stopTest();

		lsc__booking__c[] result = [
				SELECT Id, lsc__LeadContact__c, lsc__Account__c, lsc__LeadContact__r.AccountId, lsc__Event__c,
						lsc__Event__r.lsc__Course__c, lsc__Event__r.lsc__Course__r.lsc__CourseArea__c,
						lsc__Event__r.lsc__Venue__c, lsc__Event__r.lsc__Venue__r.lsc__Location__c
				FROM lsc__booking__c
				WHERE Id IN:rsBookings
		];

		System.assertEquals(5, result.size());
		System.assertEquals(1, getIdsAsSet(result, 'lsc__LeadContact__c').size());
		System.assertEquals(1, getIdsAsSet(result, 'lsc__Account__c').size());
		System.assertEquals(1, getIdsAsSet(result, 'lsc__Event__c').size());
		System.assertEquals(1, getIdsAsSet(result, 'lsc__Event__r.lsc__Course__c').size());
		System.assertEquals(1, getIdsAsSet(result, 'lsc__Event__r.lsc__Course__r.lsc__CourseArea__c').size());
		System.assertEquals(1, getIdsAsSet(result, 'lsc__Event__r.lsc__Venue__c').size());
		System.assertEquals(1, getIdsAsSet(result, 'lsc__Event__r.lsc__Venue__r.lsc__Location__c').size());

		for ( lsc__booking__c rs : result ) {
			System.assertEquals(rs.lsc__Account__c, rs.lsc__LeadContact__r.AccountId);
		}
	}


	public static Set<Id> getIdsAsSet(SObject[] objList, String fieldPath) {
		Set<Id> ids = new Set<Id>();

		for ( SObject obj : objList ) {
			String[] pathFields = fieldPath.split('\\.');

			for ( Integer i=0; i<pathFields.size(); i++ ) {
				if ( i < pathFields.size() - 1 ) {
					obj = obj.getSObject(pathFields[i]);
				} else {
					Id idValue = (Id)obj.get(pathFields[i]);

					if ( idValue != null ) {
						ids.add(idValue);
					}
				}
			}
		}

		return ids;
	}

}
