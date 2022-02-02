# NapaValley

Script to download, process, save, and publsih  resolution logs. You need to save your password in the auth env


download -> move -> procees -> pusht_html -> save to S3

```shell

ruby napavalley.rb download 2022 01
ruby napavalley.rb move 2022 01
ruby napavalley.rb process 2022 01
ruby napavalley.rb push_tml 2022 01
ruby napavalley.rb s3ve 2022 01

```
