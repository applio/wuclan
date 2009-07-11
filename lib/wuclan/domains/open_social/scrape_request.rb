
# http://wiki.opensocial.org/index.php?title=Main_Page
#
#
#

# http://api.example.org/people/userID/@me
# http://api.example.org/people/userID/@self
# http://api.example.org/people/userID/@friends
# http://api.example.org/people/userID/@all
# http://api.example.org/activities/userID/appID/selector

# format count startIndex updatedSince
# <person>, <group>, <activity>, or <appdata>.

module Wuclan
  module Domains
    module OpenSocial
      class OpsoUserRequest
      end
    end
  end
end


# aboutMe, bodyType,currentLocation, drinker, ethnicity, fashion, happiestWhen, humor, livingArrangement, lookingFor, profileSong,profileVideo, relationshipStatus, religion, romance, scaredOf, sexualOrientation, smoker, and status
# Field Name            Description
# anniversary           The wedding anniversary of this person. The value MUST be a valid xs:date (e.g. 1975-02-14). The year value MAY be set to 0000 when the year is not available.
# birthday              The birthday of this person. The value MUST be a valid xs:date (e.g. 1975-02-14). The year value MAY be set to0000 when the age of the Person is private or the year is not available.
# connected             Boolean value indicating whether the user and this Person have established a bi-directionally asserted connection of some kind on the Service Provider's service. The value MUST be either true or false. The value MUST be true if and only if there is at least one value for the relationship field, described below, and is thus intended as a summary value indicating that some type of bi-directional relationship exists, for Consumers that aren't interested in the specific nature of that relationship. For traditional address books, in which a user stores information about other contacts without their explicit acknowledgment, or for services in which users choose to "follow" other users without requiring mutual consent, this value will always be false.
# displayName           The name of this Person, suitable for display to end-users. Each Person returned MUST include a non-emptydisplayName value. The name SHOULD be the full name of the Person being described if known (e.g. Cassandra Doll or Mrs. Cassandra Lynn Doll, Esq.), but MAY be a username or handle, if that is all that is available (e.g. doll). The value provided SHOULD be the primary textual label by which this Person is normally displayed by the Service Provider when presenting it to end-users.
# gender                The gender of this person. Service Providers SHOULD return one of the following Canonical Values, if appropriate:male, female, or undisclosed, and MAY return a different value if it is not covered by one of these Canonical Values.
# id                    Unique identifier for the Person. Each Person returned MUST include a non-empty id value. This identifier MUST be unique across this user's entire set of people, but MAY not be unique across multiple users' data. It MUST be a stable ID that does not change when the same contact is returned in subsequent requests. For instance, an e-mail address is not a good id, because the same person may use a different e-mail address in the future. Usually, in internal database ID will be the right choice here, e.g. "12345".
# name                  The broken-out components and fully formatted version of the person's real name, as described in Section 11.1.3 (name Element).
# nickname              The casual way to address this Person in real life, e.g. "Bob" or "Bobby" instead of "Robert". This field SHOULD NOT be used to represent a user's username (e.g. jsmarr or daveman692); the latter should be represented by the preferredUsername field.
# note                  Notes about this person, with an unspecified meaning or usage (normally notes by the user about this person). This field MAY contain newlines.
# preferredUsername     The preferred username of this person on sites that ask for a username (e.g. jsmarr or daveman692). This field may be more useful for describing the owner (i.e. the value when /@me/@self is requested) than the user's person, e.g. Consumers MAY wish to use this value to pre-populate a username for this user when signing up for a new service.
# published             The date this Person was first added to the user's address book or friends list (i.e. the creation date of this entry). The value MUST be a valid [xs:dateTime] (e.g. 2008-01-23T04:56:22Z).
# updated               The most recent date the details of this Person were updated (i.e. the modified date of this entry). The value MUST be a valid [xs:dateTime] (e.g. 2008-01-23T04:56:22Z). If this Person has never been modified since its initial creation, the value MUST be the same as the value of published. Note the updatedSince Query Parameter can be used to select only people whose updated value is equal to or more recent than a given xs:dateTime. This enables Consumers to repeatedly access a user's data and only request newly added or updated contacts since the last access time.
# utcOffset             The offset from UTC of this Person's current time zone, as of the time this response was returned. The value MUST conform to the offset portion of [xs:dateTime], e.g. -08:00. Note that this value MAY change over time due to daylight saving time, and is thus meant to signify only the current value of the user's timezone offset.

# plural fields
#
# Field Name            Description
# value                 The primary value of this field, e.g. the actual e-mail address, phone number, or URL. When specifying a sortByfield in the Query Parameters for a Plural Field, the default meaning is to sort based on this value sub-field. Each non-empty Plural Field value MUST contain at least the value sub-field, but all other sub-fields are optional.
# type                  The type of field for this instance, usually used to label the preferred function of the given contact information. Unless otherwise specified, this string value specifies Canonical Values of work, home, and other.
# primary               A Boolean value indicating whether this instance of the Plural Field is the primary or preferred value of for this field, e.g. the preferred mailing address or primary e-mail address. Service Providers MUST NOT mark more than one instance of the same Plural Field as primary="true", and MAY choose not to mark any fields as primary, if this information is not available. For efficiency, Service Providers SHOULD NOT mark all non-primary fields with primary="false", but should instead omit this sub-field for all non-primary instances.
# When returning Plural Fields, Service Providers SHOULD canonicalize the value returned, if appropriate (e.g. for e-mail addresses and URLs). Providers MAY return the same value more than once with different types (e.g. the same e-mail address may used for work and home), but SHOULD NOT return the same (type, value) combination more than once per Plural Field, as this complicates processing by the Consumer.
#
# Field Name            Description
# emails                E-mail address for this Person. The value SHOULD be canonicalized by the Service Provider, e.g.joseph@plaxo.com instead of joseph@PLAXO.COM.
# urls                  URL of a web page relating to this Person. The value SHOULD be canonicalized by the Service Provider, e.g.http://josephsmarr.com/about/ instead of JOSEPHSMARR.COM/about/. In addition to the standard Canonical Values for type, this field also defines the additional Canonical Values blog and profile.
# phoneNumbers          Phone number for this Person. No canonical value is assumed here. In addition to the standard Canonical Values for type, this field also defines the additional Canonical Values mobile, fax, and pager.
# ims                   Instant messaging address for this Person. No official canonicalization rules exist for all instant messaging addresses, but Service Providers SHOULD remove all whitespace and convert the address to lowercase, if this is appropriate for the service this IM address is used for. Instead of the standard Canonical Values for type, this field defines the following Canonical Values to represent currently popular IM services: aim, gtalk, icq, xmpp,msn, skype, qq, and yahoo.
# photos                URL of a photo of this person. The value SHOULD be a canonicalized URL, and MUST point to an actual image file (e.g. a GIF, JPEG, or PNG image file) rather than to a web page containing an image. Service Providers MAY return the same image at different sizes, though it is recognized that no standard for describing images of various sizes currently exists. Note that this field SHOULD NOT be used to send down arbitrary photos taken by this user, but specifically profile photos of the contact suitable for display when describing the contact.
# tags                  A user-defined category label for this person, e.g. "favorite" or "web20". These values SHOULD be case-insensitive, and there SHOULD NOT be multiple tags provided for a given person that differ only in case. Note that this field consists only of a string value.
# relationships         A bi-directionally asserted relationship type that was established between the user and this person by the Service Provider. The value SHOULD conform to one of the XFN relationship values (e.g. kin, friend, contact, etc.) if appropriate, but MAY be an alternative value if needed. Note this field is a parallel set of category labels to the tags field, but relationships MUST have been bi-directionally confirmed, whereas tags are asserted by the user without acknowledgment by this Person. Note that this field consists only of a string value.
# addresses             A physical mailing address for this Person, as described in Section 11.1.4 (address Element).
# organizations         A current or past organizational affiliation of this Person, as described in Section 11.1.5 (organization Element).
# accounts              An online account held by this Person, as described in Section 11.1.6 (account Element).
# appdata               A collection of AppData keys and values, as described in Section 3.5.1 (an isolated AppData example).
#
# The following additional Plural Fields are defined, based on their specification in OpenSocial: activities, books, cars, children,food, heroes, interests, jobInterests, languages, languagesSpoken, movies, music, pets, politicalViews, quotes, sports,turnOffs, turnOns, and tvShows.

# Activity fields
#
# The following fields are defined, based on their specification in the OpenSocial JavaScript apis: appId, body, bodyId, externalId, id, mediaItems, postedTime, priority, streamFaviconUrl, streamSourceUrl, streamTitle, streamUrl, templateParams, title, url, userId.

#  Message fields
#
# The following fields are defined, based on their specification in the OpenSocial JavaScript apis: type, title, body, titleId, bodyId, id, recipients, senderId, timeSent, inReplyTo, replies, status, appUrl, collectionIds, updated, urls.
