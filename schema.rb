# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090826135440) do

  create_table "activities", :force => true do |t|
    t.text     "description", :limit => 2147483647,                    :null => false
    t.integer  "job_id",                                               :null => false
    t.string   "action",      :limit => 1
    t.datetime "created_at",                                           :null => false
    t.integer  "created_by",                                           :null => false
    t.boolean  "submitted",                         :default => false, :null => false
    t.integer  "sequence",                          :default => 1,     :null => false
  end

  add_index "activities", ["job_id"], :name => "job_id_activities"

  create_table "additional_informations_jobs", :force => true do |t|
    t.integer  "job_id",                                                :null => false
    t.string   "profile_type", :limit => 1,                             :null => false
    t.text     "description",  :limit => 2147483647,                    :null => false
    t.integer  "created_by",                                            :null => false
    t.datetime "created_at",                                            :null => false
    t.string   "action",       :limit => 1
    t.boolean  "submitted",                          :default => false, :null => false
  end

  add_index "additional_informations_jobs", ["job_id", "profile_type"], :name => "IX_additional_informations_jobs"

  create_table "categories", :force => true do |t|
    t.string  "name",              :limit => 100, :null => false
    t.integer "category_group_id"
  end

  add_index "categories", ["category_group_id"], :name => "FK_categories_category_groups"

  create_table "classification_levels", :force => true do |t|
    t.string  "name",              :limit => 50, :null => false
    t.integer "classification_id",               :null => false
  end

  add_index "classification_levels", ["classification_id"], :name => "FK_classification_levels_classifications"

  create_table "classifications", :force => true do |t|
    t.string "name", :limit => 50, :null => false
  end

  create_table "comments", :force => true do |t|
    t.integer  "user_id",                            :null => false
    t.text     "comment",      :limit => 2147483647
    t.datetime "date",                               :null => false
    t.string   "profile_type", :limit => 1
  end

  add_index "comments", ["user_id"], :name => "FK_comments_users"

  create_table "comments_jobs", :id => false, :force => true do |t|
    t.integer "comment_id", :null => false
    t.integer "job_id",     :null => false
  end

  add_index "comments_jobs", ["job_id"], :name => "FK_comments_jobs_jobs"

  create_table "comments_processes", :id => false, :force => true do |t|
    t.integer "comment_id", :null => false
    t.integer "process_id", :null => false
  end

  add_index "comments_processes", ["process_id"], :name => "FK_comments_processes_processes"

  create_table "competencies", :force => true do |t|
    t.integer "category_id"
    t.string  "name",        :limit => 1000,                    :null => false
    t.boolean "display",                     :default => false, :null => false
  end

  add_index "competencies", ["category_id"], :name => "category_id_competencies"

  create_table "competencies_definitions", :id => false, :force => true do |t|
    t.integer "competency_id",                :null => false
    t.integer "definition_id",                :null => false
    t.integer "sequence",      :default => 1, :null => false
  end

  add_index "competencies_definitions", ["competency_id"], :name => "competencies_definitions_compet"
  add_index "competencies_definitions", ["definition_id"], :name => "IX_competencies_definitions"

  create_table "competencies_groups_jobs", :id => false, :force => true do |t|
    t.integer  "job_id",                                        :null => false
    t.integer  "competency_id",                                 :null => false
    t.integer  "group_id",                                      :null => false
    t.datetime "created_at",                                    :null => false
    t.integer  "created_by",                                    :null => false
    t.string   "action",        :limit => 1, :default => "0"
    t.boolean  "submitted",                  :default => false, :null => false
    t.integer  "sequence",                   :default => 1,     :null => false
  end

  add_index "competencies_groups_jobs", ["competency_id"], :name => "FK_job_competencies_competencies"
  add_index "competencies_groups_jobs", ["created_by"], :name => "FK_job_competencies_users"
  add_index "competencies_groups_jobs", ["job_id", "group_id"], :name => "FK_groups_jobs"
  add_index "competencies_groups_jobs", ["job_id"], :name => "IX_competencies_groups_jobs"

  create_table "competencies_levels", :id => false, :force => true do |t|
    t.integer "competency_id",                :null => false
    t.integer "level_id",                     :null => false
    t.integer "sequence",      :default => 1, :null => false
  end

  add_index "competencies_levels", ["level_id"], :name => "FK_competencies_levels_levels"

  create_table "competencies_resources", :id => false, :force => true do |t|
    t.integer "competency_id", :null => false
    t.integer "resource_id",   :null => false
  end

  add_index "competencies_resources", ["competency_id"], :name => "IX_competencies_resources"
  add_index "competencies_resources", ["resource_id"], :name => "IX_competencies_resources_1"

  create_table "default_competencies_groups", :id => false, :force => true do |t|
    t.integer "competency_id", :null => false
    t.integer "group_id",      :null => false
  end

  add_index "default_competencies_groups", ["group_id"], :name => "FK_default_competencies_groups_groups"

  create_table "definitions", :force => true do |t|
    t.text    "description", :limit => 2147483647,                    :null => false
    t.boolean "behaviour",                         :default => false, :null => false
    t.boolean "heading",                           :default => false, :null => false
  end

  create_table "draft_activities", :primary_key => "activity_id", :force => true do |t|
    t.text "new_value", :limit => 2147483647, :null => false
  end

  create_table "draft_additional_informations", :primary_key => "additional_information_id", :force => true do |t|
    t.text "new_value", :limit => 2147483647, :null => false
  end

  create_table "draft_qualifications", :primary_key => "qualification_id", :force => true do |t|
    t.text "new_value", :limit => 2147483647, :null => false
  end

  create_table "dtproperties", :force => true do |t|
    t.integer "objectid"
    t.string  "property", :limit => 64,                        :null => false
    t.string  "value"
    t.string  "uvalue"
    t.binary  "lvalue",   :limit => 2147483647
    t.integer "version",                        :default => 0, :null => false
  end

  create_table "functional_communities_jobs", :force => true do |t|
    t.text     "name",       :limit => 2147483647,                    :null => false
    t.integer  "job_id",                                              :null => false
    t.datetime "created_at",                                          :null => false
    t.integer  "created_by",                                          :null => false
    t.string   "action",     :limit => 1
    t.boolean  "submitted",                        :default => false, :null => false
    t.integer  "sequence",                         :default => 1,     :null => false
  end

  create_table "groups", :force => true do |t|
    t.string  "name",        :limit => 50,  :null => false
    t.integer "section_id",                 :null => false
    t.string  "description", :limit => 250
  end

  add_index "groups", ["section_id"], :name => "FK_groups_sections"

  create_table "groups_jobs", :id => false, :force => true do |t|
    t.integer  "job_id",                                     :null => false
    t.integer  "group_id",                                   :null => false
    t.string   "action",     :limit => 1, :default => "0"
    t.datetime "created_at",                                 :null => false
    t.integer  "created_by",                                 :null => false
    t.boolean  "submitted",               :default => false, :null => false
  end

  create_table "jobs", :force => true do |t|
    t.string   "title",                   :limit => 250,                    :null => false
    t.string   "branch",                  :limit => 300
    t.integer  "classification_level_id",                                   :null => false
    t.boolean  "display",                                :default => false, :null => false
    t.datetime "modification_date"
    t.boolean  "draft",                                  :default => false
  end

  add_index "jobs", ["classification_level_id"], :name => "FK_jobs_classification_levels"
  add_index "jobs", ["title", "branch", "classification_level_id"], :name => "IX_jobs", :unique => true

  create_table "jobs_sections", :id => false, :force => true do |t|
    t.integer  "job_id",                                   :null => false
    t.integer  "section_id",                               :null => false
    t.string   "action",     :limit => 1, :default => "0"
    t.datetime "created_at",                               :null => false
    t.integer  "created_by",                               :null => false
  end

  add_index "jobs_sections", ["section_id"], :name => "FK_jobs_sections_sections"

  create_table "jobs_technical_tasks", :id => false, :force => true do |t|
    t.integer  "job_id",                                        :null => false
    t.integer  "competency_id",                                 :null => false
    t.string   "action",        :limit => 1
    t.datetime "created_at",                                    :null => false
    t.integer  "created_by",                                    :null => false
    t.boolean  "submitted",                  :default => false, :null => false
    t.integer  "sequence",                   :default => 1,     :null => false
  end

  add_index "jobs_technical_tasks", ["competency_id"], :name => "FK_jobs_technical_tasks_competencies"

  create_table "language_considerations", :force => true do |t|
    t.string "name", :limit => 20, :null => false
  end

  create_table "levels", :force => true do |t|
    t.string "name",        :limit => 100, :null => false
    t.string "description", :limit => 200
  end

  create_table "levels_definitions", :id => false, :force => true do |t|
    t.integer "level_id",                     :null => false
    t.integer "definition_id",                :null => false
    t.integer "sequence",      :default => 1, :null => false
  end

  add_index "levels_definitions", ["definition_id"], :name => "FK_level_definitions_definitions"

  create_table "news", :force => true do |t|
    t.string   "title",           :limit => 250,        :null => false
    t.text     "description",     :limit => 2147483647, :null => false
    t.datetime "creation_date",                         :null => false
    t.datetime "expiration_date",                       :null => false
  end

  create_table "phases", :force => true do |t|
    t.string  "name",            :limit => 250,                    :null => false
    t.integer "sequence_number",                                   :null => false
    t.boolean "deleted",                        :default => false, :null => false
  end

  create_table "pools", :force => true do |t|
    t.integer  "process_id",                                    :null => false
    t.integer  "classification_level_id",                       :null => false
    t.integer  "contact_id",                                    :null => false
    t.text     "description",             :limit => 2147483647
    t.datetime "expiry_date"
  end

  create_table "positions", :force => true do |t|
    t.integer "job_id",                                                             :null => false
    t.integer "security_level_id",                                                  :null => false
    t.integer "tenure_id",                                                          :null => false
    t.integer "process_id"
    t.integer "manager_id",                                                         :null => false
    t.integer "language_consideration_id",                                          :null => false
    t.string  "number",                    :limit => 50,                            :null => false
    t.text    "rationale",                 :limit => 2147483647
    t.text    "comments",                  :limit => 2147483647
    t.string  "fiscal_year",               :limit => 4,                             :null => false
    t.string  "location",                  :limit => 250
    t.boolean "infrastructure",                                  :default => false, :null => false
  end

  add_index "positions", ["job_id"], :name => "FK_positions_jobs"
  add_index "positions", ["language_consideration_id"], :name => "FK_positions_language_considerations"
  add_index "positions", ["manager_id"], :name => "FK_positions_staffing_users"
  add_index "positions", ["process_id"], :name => "FK_positions_processes"
  add_index "positions", ["security_level_id"], :name => "FK_positions_security_levels"
  add_index "positions", ["tenure_id"], :name => "FK_positions_tenures"

  create_table "positions_users", :id => false, :force => true do |t|
    t.integer "position_id", :null => false
    t.integer "user_id",     :null => false
  end

  add_index "positions_users", ["user_id"], :name => "FK_positions_users_staffing_users"

  create_table "processes", :force => true do |t|
    t.integer  "board_chair_id",                    :null => false
    t.integer  "staffing_method_id",                :null => false
    t.integer  "phase_id",                          :null => false
    t.integer  "status_id",                         :null => false
    t.string   "number",             :limit => 100, :null => false
    t.datetime "cancelation_date"
    t.datetime "completion_date"
    t.boolean  "collective",                        :null => false
  end

  add_index "processes", ["board_chair_id"], :name => "FK_processes_staffing_users"
  add_index "processes", ["phase_id"], :name => "FK_processes_phases"
  add_index "processes", ["staffing_method_id"], :name => "FK_processes_staffing_methods"
  add_index "processes", ["status_id"], :name => "FK_processes_statuses"

  create_table "processes_staffing_activities", :force => true do |t|
    t.integer  "activity_id",         :null => false
    t.integer  "process_id",          :null => false
    t.integer  "status_id",           :null => false
    t.datetime "est_completion_date"
    t.datetime "completion_date"
    t.integer  "endangered_time",     :null => false
  end

  add_index "processes_staffing_activities", ["activity_id"], :name => "FK_position_activities_staffing_activities"
  add_index "processes_staffing_activities", ["process_id"], :name => "FK_processes_staffing_activities_processes"
  add_index "processes_staffing_activities", ["status_id"], :name => "FK_position_activities_statuses"

  create_table "qualification_groups", :force => true do |t|
    t.string "name", :limit => 100, :null => false
  end

  create_table "qualifications", :force => true do |t|
    t.text     "description",            :limit => 2147483647,                    :null => false
    t.integer  "job_id",                                                          :null => false
    t.integer  "qualification_group_id",                                          :null => false
    t.string   "action",                 :limit => 1
    t.datetime "created_at",                                                      :null => false
    t.integer  "created_by",                                                      :null => false
    t.boolean  "submitted",                                    :default => false, :null => false
    t.integer  "sequence",                                     :default => 1,     :null => false
  end

  add_index "qualifications", ["job_id"], :name => "FK_qualifications_jobs"

  create_table "resource_categories", :force => true do |t|
    t.string "name", :limit => 250, :null => false
  end

  create_table "resources", :force => true do |t|
    t.integer "category_id",                       :null => false
    t.string  "title",       :limit => 250,        :null => false
    t.text    "description", :limit => 2147483647
    t.string  "code",        :limit => 500
  end

  add_index "resources", ["category_id"], :name => "FK_resources_resource_categories"

  create_table "sections", :force => true do |t|
    t.string "name", :limit => 100, :null => false
  end

  create_table "security_levels", :force => true do |t|
    t.string "name", :limit => 50, :null => false
  end

  create_table "staffing_activities", :force => true do |t|
    t.string  "name",                    :limit => 250,                :null => false
    t.integer "phase_id",                                              :null => false
    t.integer "sequence",                                              :null => false
    t.boolean "deleted",                                               :null => false
    t.integer "default_endangered_time",                :default => 7, :null => false
  end

  add_index "staffing_activities", ["phase_id"], :name => "FK_activities_phases"

  create_table "staffing_activities_staffing_methods", :id => false, :force => true do |t|
    t.integer "activity_id",        :null => false
    t.integer "staffing_method_id", :null => false
  end

  create_table "staffing_comments", :force => true do |t|
    t.integer  "user_id",                       :null => false
    t.text     "comment", :limit => 2147483647
    t.datetime "date",                          :null => false
  end

  add_index "staffing_comments", ["user_id"], :name => "FK_staffing_comments_staffing_users"

  create_table "staffing_methods", :force => true do |t|
    t.string "name", :limit => 250, :null => false
  end

  create_table "staffing_users", :force => true do |t|
    t.string "login", :limit => 100, :null => false
  end

  create_table "statuses", :force => true do |t|
    t.string  "name",            :limit => 250,                    :null => false
    t.boolean "activity_status",                :default => false, :null => false
  end

  create_table "tenures", :force => true do |t|
    t.string "name", :limit => 50, :null => false
  end

  create_table "test", :force => true do |t|
    t.string "name"
  end

  create_table "transactions", :force => true do |t|
    t.integer  "user_id",                                   :null => false
    t.integer  "process_activity_id",                       :null => false
    t.datetime "datetime",                                  :null => false
    t.text     "old_value",           :limit => 2147483647
    t.text     "new_value",           :limit => 2147483647
    t.text     "action",              :limit => 2147483647, :null => false
  end

  add_index "transactions", ["process_activity_id"], :name => "FK_transactions_processes_staffing_activities"
  add_index "transactions", ["user_id"], :name => "FK_transactions_staffing_users"

  create_table "user_jobs", :id => false, :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "job_id",     :null => false
    t.datetime "created_at", :null => false
  end

  add_index "user_jobs", ["job_id"], :name => "FK_user_jobs_jobs"

  create_table "user_news", :id => false, :force => true do |t|
    t.integer "user_id", :null => false
    t.integer "news_id", :null => false
  end

  add_index "user_news", ["news_id"], :name => "FK_user_news_news"

  create_table "user_positions", :id => false, :force => true do |t|
    t.integer "user_id",     :null => false
    t.integer "position_id", :null => false
  end

  add_index "user_positions", ["position_id"], :name => "FK_user_positions_positions"
  add_index "user_positions", ["user_id"], :name => "FK_user_positions_staffing_users"

  create_table "users", :force => true do |t|
    t.string "login", :limit => 100, :null => false
  end

end
