# manually with Sublime
# 1. deleted CSS code
#-------------------------------------------
# 2. correcting class
#
##### before
# \"array\"
##### after
# "array"
#-------------------------------------------
# 3. added class for type 1 tables:
#
##### before
#<table>
#	<thead>
#		<tr>
#			<th class=\"string\">name</th>
#			<th class=\"string\">mean</th>
#			<th class=\"string\">stdev</th>
#		</tr>
#	</thead>
#	<tbody>
#		<tr>
#
##### after
#<table>
#	<thead>
#		<tr>
#			<th class="string">name</th>
#			<th class="string">mean</th>
#			<th class="string">stdev</th>
#		</tr>
#	</thead>
#	<tbody class="type1">
#		<tr>
#-------------------------------------------
# 4. added class for type 2 tables:
#
##### before
#<table>
#	<thead>
#		<tr>
#			<th class=\"string\">name</th>
#			<th class=\"array\">answers</th>
#		</tr>
#	</thead>
#	<tbody>
#			<tr>
#
##### after
#<table>
#	<thead>
#		<tr>
#			<th class="string type2">name</th>
#			<th class="array type2">answers</th>
#		</tr>
#	</thead>
#	<tbody class="type2">
#			<tr>
#-------------------------------------------
# 5. added class for type 3 tables:
#
##### before
#<table>
#	<thead>
#		<tr>
#			<th class=\"string\">Reference</th>
#
##### after
#<table class="type3">
#  <thead>
#  	<tr class="type3">
#    	<th class="string type3">Reference</th>
#-------------------------------------------
# reading libraries
library(rvest)
library(tidyverse)
library(varhandle)

# reading HTML file without CSS
poll_data <- read_html("~/Downloads/Porto Alegre.html", encoding = "UTF-8")

# choosing questions - TYPE 1
type1_chosen_questions <- data.frame(questions = c("favor_lula_prison",
                            "agree_with_impeachment_of_bolsonaro",
                            "position_abortion",
                            "position_hemp",
                            "vote_in_2022_A",
                            "vote_2018_second_round",
                            "agree_measures_to_stop_coronavirus",
                            "personal_cicle_infect",
                            "more_concerned_with_economy_or_losing_relatives",
                            "social_isolation_should_increase_decrease",
                            "is_infected_by_coronavirus",
                            "religion",
                            "facebook_user",
                            "gender",
                            "educational_level",
                            "age",
                            "family_income",
                            "vote_mayoral_elections_first_round_2020",
                            "vote_second_round_manueladavila_nelsonmarchezanjr",
                            "neighborhood",
                            "region"))

# choosing questions - TYPE 2
type2_chosen_questions <- data.frame(questions = c("positive_or_negative_image_of",
                            "image_of_local_politicians",
                            "evaluation_of_eduardoleite_nelsonmarchezanjr_government"))


# getting question for type 2 tables
# https://stackoverflow.com/questions/62390373/how-to-get-html-element-that-is-before-a-certain-class


