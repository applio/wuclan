# http://wiki.developers.facebook.com/index.php/Authorization_and_Authentication_for_Desktop_Applications#Prompting_for_Permissions
# http://wiki.developers.facebook.com/index.php/Extended_permissions


#     *  api_key=YOURAPIKEY
#     * fbconnect=true
#     * v=1.0
#     * connect_display=popup
#     * return_session=true. This requests a session from Facebook.
#     * next=URL: The next URL to request after the user logs in to your application. This URL either can be a subdomain of your Connect URL (which you specify in your application settings) or it can be anywhere on the facebook.com domain, like www.facebook.com/connect/login_success.html.
#     * cancel_url=URL: The next URL to request if the user cancels or otherwise cannot log in successfully. This URL either can be a subdomain of your Connect URL or it can be anywhere on Facebook, like www.facebook.com/connect/login_failure.html.
#     * req_perms=permission,permission,permission: A comma-separated list of extended permissions you are requesting from the user.
#
# For example, the full URL for logging in a user could be:
# http://www.facebook.com/login.php
#    ?api_key=YOURAPIKEY
#    &connect_display=popup
#    &v=1.0
#    &next=http://www.facebook.com/connect/login_success.html
#    &cancel_url=http://www.facebook.com/connect/login_failure.html # This URL either can be a subdomain of your Connect URL or it can be anywhere on Facebook, like www.facebook.com/connect/login_failure.html.
#    &fbconnect=true
#    &return_session=true
#    &req_perms=read_stream,publish_stream,offline_access


# When you configure an application with the Facebook Developer application, you are given an API key and an application secret. You can disregard the application secret and you should never include it in your desktop application's code, as it can be decompiled and used maliciously.
#
# Instead, you get a session secret when the user authorizes your application, as described above. You should store it along with the session key, typically on the user's desktop where the user installed your application.
#
# Desktop sessions last 24 hours, or until the user logs out of your application. The session secret expires when the session key does.
#


# read_stream     Lets your application or site access a user's stream and display it. This includes all of the posts in a user's stream. You need an active session with the user to get this data.
# offline_access  This permission grants an application access to user data when the user is offline or doesn't have an active session. This permission can be obtained only through the fb:prompt-permission tag or the promptpermission attribute. Read more about session keys.
# # email           This permission allows an application to send email to its user. This permission can be obtained only through the fb:prompt-permission tag or the promptpermission attribute. When the user accepts, you can send him/her an email via notifications.sendEmail or directly to the proxied_email FQL field.
# # create_event    This permission allows an app to create and modify events for a user via the events.create, events.edit and events.cancel methods.
# # rsvp_event      This permission allows an app to RSVP to an event on behalf of a user via the events.rsvp method.
# # sms             This permission allows a mobile application to send messages to the user and respond to messages from the user via text message.
# # publish_stream          Lets your application or site post content, comments, and likes to a user's profile and in the streams of the user's friends without prompting the user. This permission is a superset of the status_update, photo_upload, video_upload, create_note, and share_item extended permissions, so if you haven't prompted users for those permissions yet, you need only prompt them for publish_stream.
# # status_update   This permission grants your application the ability to update a user's or Facebook Page's status with the status.set or users.setStatus method. Note: You should prompt users for the publish_stream permission instead, since it includes the ability to update a user's status.
# # photo_upload    This permission relaxes requirements on the photos.upload and photos.addTag methods. If the user grants this permission, photos uploaded by the application will bypass the pending state and the user will not have to manually approve the photos each time. Note: You should prompt users for the publish_stream permission instead, since it includes the ability to upload a photo.
# # video_upload    This permission allows an application to provide the mechanism for a user to upload videos to their profile. Note: You should prompt users for the publish_stream permission instead, since it includes the ability to upload a video.
# # create_note     This permission allows an application to provide the mechanism for a user to write, edit, and delete notes on their profile. Note: You should prompt users for the publish_stream permission instead, since it includes the ability to let a user write notes.
# # share_item      This permission allows an application to provide the mechanism for a user to post links to their profile. Note: You should prompt users for the publish_stream permission instead, since it includes the ability to let a user share links.
