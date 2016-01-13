# operations-dashboard

## Slack-Integration
A Widget for the Dashing Board to display the Status of your Teammembers (Available or Away).
Filters out external workers and bots.

### Usage
To use the Slack-Integration paste the following into your Dashboard .erb file:
```
<li data-row="1" data-col="1" data-sizex="1" data-sizey="2">
<div data-id="slack-integration" data-view="Slack" data-unordered="true" data-title="Slack activity" data-moreinfo="Users online"></div>
</li>
```
If you want to change the size of the Widget just change the value of data-sizex for more width and data-sizey for more height.
Also make sure, that you start Dashing with your Slack-API Key.
Just start dashing like this:
```
SLACKAPIKEY=your_api_key_goes_here dashing start
```
or if you host it on Heroku for example, store the key in the Config Vars (KEY -> SLACKAPIKEY, VALUE -> your_api_key-goes_here).
To get your Slack-API Key visit https://api.slack.com/applications.

If you want to change the colors of the Widget, just open the slack.scss file inside the widgets folder.


## GitHub-Integration
Widget to show the progress of your teams project, based on the open / closed Issues per Milestone.
Filters out any repository that doesn't have Milestones. So Issues need to be assigned to a Milestone to be Displayed by this Widget.

### Usage
To use the GitHub-Integration paste the following into your Dashboard .erb file:
```
<li data-row="1" data-col="1" data-sizex="1" data-sizey="1">
<div data-id="git" data-view="Git" data-unordered="true" data-title="Git status"></div>
</li>
```
If you want to change the size of the Widget just change the value of data-sizex for more width and data-sizey for more height.
Also make sure, that you start Dashing with your GitHub-API Key.
Just start dashing like this:
```
GIT_AUTH_TOKEN=your_api_key_goes_here dashing start
```

The colors of the Widget are using the original GitHub-Colors.

## Useful Tips

### Multiple ENV[vars] on startup
To start the Dashboard with a GitHub and Slack Widget, just concanate the ENV[vars] like this:
```
GIT_AUTH_TOKEN=git_api_key SLACKAPIKEY=slack_api_key dashing start
```
