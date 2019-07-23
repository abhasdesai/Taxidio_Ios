
#ifndef Webservice_h
#define Webservice_h

// For REESORT

#define WS_DOMAIN                               @"http://reesort.com/taxidio/webservices/"
#define WS_IMAGE_PATH_COUNTRY                   @"http://reesort.com/taxidio/userfiles/countries/small/"
#define WS_IMAGE_PATH_CITY                      @"http://reesort.com/taxidio/userfiles/cities/small/"
#define WS_IMAGE_PATH_ATTRACTION                @"http://reesort.com/taxidio/userfiles/images/"
#define WS_IMAGE_PATH_USER                      @"http://reesort.com/taxidio/userfiles/userimages/small/"

//LIVE Webservices
//#define WS_DOMAIN                               @"https://www.taxidio.com/webservices/"
//#define WS_IMAGE_PATH_COUNTRY                   @"https://www.taxidio.com/userfiles/countries/small/"
//#define WS_IMAGE_PATH_CITY                      @"https://www.taxidio.com/userfiles/cities/small/"
//#define WS_IMAGE_PATH_ATTRACTION                @"https://www.taxidio.com/userfiles/images/"
//#define WS_IMAGE_PATH_USER                      @"https://www.taxidio.com/userfiles/userimages/small/"

//#define WS_DOMAIN                               @"http://beta.taxidio.com/webservices/"
//#define WS_IMAGE_PATH_COUNTRY                   @"http://beta.taxidio.com/userfiles/countries/small/"
//#define WS_IMAGE_PATH_CITY                      @"http://beta.taxidio.com/userfiles/cities/small/"
//#define WS_IMAGE_PATH_ATTRACTION                @"http://beta.taxidio.com/userfiles/images/"
//#define WS_IMAGE_PATH_USER                      @"http://beta.taxidio.com/userfiles/userimages/small/"
//
// for Staging Server

//#define WS_DOMAIN                               @"http://192.168.0.148/taxidio/webservices/"
//#define WS_IMAGE_PATH_COUNTRY                   @"http://192.168.0.148/taxidio/userfiles/countries/small/"
//#define WS_IMAGE_PATH_CITY                      @"http://192.168.0.148/taxidio/userfiles/cities/small/"
//#define WS_IMAGE_PATH_ATTRACTION                @"http://192.168.0.148/taxidio/userfiles/images/"
//#define WS_IMAGE_PATH_USER                      @"http://192.168.0.148/taxidio/userfiles/userimages/small/"

#define GOOGLE_PLACE_KEY                        @"AIzaSyDXRP9OUurkE3mPXVVFgRDPhMQKCaHiu-0"

#define WS_UPGRADE_DEVICE_ID                    @"user/upgradeDeviceID"
#define WS_SIGN_UP                              @"user/signUP"
#define WS_LOGIN_USER                           @"user/signIN"
#define WS_FORGOT_PASSWORD                      @"user/forgotPassword"
#define WS_GOOGLE_LOGIN                         @"user/googleLogin"
#define WS_FACEBOOK_LOGIN                       @"user/facebookLogin"
#define WS_UPDATE_EMAIL_ID                      @"user/updateEmail"
#define WS_CHECK_UNIQUE_EMAIL                   @"user/checkUniqueEmail"
#define WS_CHECK_ASK_FOR_EMAIL                  @"user/check_ask_for_email"


#define WS_RECOMMENDATION_COUNTRY               @"recommendation/countries"
#define WS_GETACCOTYPE                          @"recommendation/getaccommodations"

#define WS_TRIP_TO_DESTINATION                  @"attractions/tripTodestination"

#define WS_GET_SUGGESTED_CITIES                 @"recommendation/getSuggestedCities"

#define WS_ADD_CITY_LIST                        @"recommendation/otherCities"

#define WS_ROME2RIO_DISCTANCE                   @"attractions/timeToreach"
#define WS_GET_ATTRACTION_CITY                  @"attractions/getAttractions"
#define WS_READ_MORE_ATTRACTION_DATA            @"attractions/getAttractionData"

#define WS_ACCOUNT_DASHBOARD                    @"account"
#define WS_TRIP_LIST                            @"trips"
#define WS_DELETE_TRIP                          @"trips/deleteTrip"
#define WS_EDIT_TRIP_DETAILS                    @"trips/updateTrip"
#define WS_EDIT_TRIP                            @"account/update_itinerary"
#define WS_GET_TRIP                             @"trips/getTrip"
#define WS_FEEDBACK_LIST                        @"feedback"
#define WS_ADD_FEEDBACK                         @"feedback/sendFeedback"
#define WS_DELETE_FEEDBACK                      @"feedback/deleteFeedback"
#define WS_SAVE_TRIP                            @"account/save_itinerary"
#define WS_GET_FAQS_LIST                        @"cms/faq"
#define WS_GET_DESTINATION_LIST                 @"cms/destination"
#define WS_GET_PRIVACY_POLICY                   @"cms/privacy_policy"
#define WS_GET_DISCOVER_TAXIDIO                 @"cms/discover_taxidio"
#define WS_GET_USER_DETAILS                     @"user"
#define WS_EDIT_USER_DETAILS                    @"user/updateProfile"
#define WS_ITINERARIES_LIST                     @"Itineraries"
#define WS_SAVE_COPY_ITINERARIES                @"Itineraries/copy_itinerary"
#define WS_GET_ITINERARIES_DETAILS              @"Itineraries/get_planned_itinerary_details"
#define WS_ITINERARIES_FORUM_LIST               @"forum"
#define WS_ADD_UPDATE_RATING_FORUM              @"forum/store_rating"
#define WS_ADD_FORUM_QUESTION                   @"forum/addQuestion"
#define WS_FORUM_MY_QUESTION                    @"forum/myquestions"
#define WS_FORUM_REPLY                          @"forum/itinerary_discussion"
#define WS_DELETE_COMMENT_QUESTION              @"forum/deleteComment"
#define WS_DELETE_QUESTION                      @"forum/deleteQuestion"
#define WS_ADD_COMMENT                          @"forum/postComment"
#define WS_EDIT_COMMENT                         @"forum/editComment"

#define WS_CHANGE_PASSWORD                      @"user/changePassword"

#define WS_ADD_DELETE_SEARCH_CITY               @"attractions/getOtherCitiesforSearchedCity"

#define WS_HOTEL_GET_DETAILS                    @"hotels/get_city_hotels"

#define WS_GET_COUNTRY_CODE                     @"user/getCountryCodes"
#define WS_ADD_SOS_DETAILS                      @"user/addSOS"
#define WS_UPDATE_SOS_DETAILS                   @"user/updateSOS"
#define WS_GET_ALL_SOS_CONTACTS                 @"user/getAllSOSOfUser"
#define WS_GET_SOS_DETAILS_SELECTED_ID          @"user/getSOSById"
#define WS_DELETE_SOS_DETAILS_SELECTED_ID       @"user/deleteSOS"

#define WS_INVITED_TRIP_LIST                    @"share_iti/invited_trips"
#define WS_SHARE_TRIP_WITH_MEMBER               @"share_iti/share_iti_with_member"
#define WS_NEW_TRIP_INVITE_POPUP                @"share_iti/new_invited_trips"
#define WS_NEW_TRIP_INVITE_VIEWED               @"share_iti/notification_viewed"

#endif /* Webservice_h */
