# """Tests for Nautobot Rundeck worker."""
# # Testing protected members  # pylint: disable=protected-access
# # Testing Class is quite full of tests:  # pylint: disable=too-many-public-methods
# import datetime
# import os
# from unittest import TestCase
# from unittest.mock import MagicMock, call, patch
#
# import responses
# from django.conf import settings
# from nautobot_chatops.dispatchers.slack import SlackDispatcher, WebClient
#
# from nautobot_chatops_extension_rundeck import worker
# from nautobot_chatops_extension_rundeck.rundeck import Rundeck
# from nautobot_chatops_extension_rundeck.tests.fixtures import real_path
# from nautobot_chatops_extension_rundeck.tests.utilities import json_fixture
#
# FIXTURES = os.environ.get("FIXTURE_DIR", real_path)
#
#
# class TestSlackDispatcher(TestCase):
#     """Test the SlackDispatcher class."""
#
#     dispatcher_class = SlackDispatcher
#     platform_name = "Slack"
#     enable_opt_name = "enable_slack"
#
#     def setUp(self):
#         """Setup Class."""
#         settings.PLUGINS_CONFIG["nautobot_chatops"][self.enable_opt_name] = True
#         self.dispatcher = self.dispatcher_class(
#             context={
#                 "user_name": "Hugo",
#                 "user_id": "UserID69",
#                 "channel_id": "T02HVAUAYD9",
#                 "request_scheme": "SomeScheme",
#                 "request_host": "SomeHost",
#             }
#         )
#         self.uri = "https://rundeck-server.com"
#         self.token = "junkToken"
#         # self.api_version = "40"
#         self.rundeck = Rundeck(self.uri, self.token)
#         self.job_id = "cc2d5f73-0479-4601-9986-f759ea87f18b"
#
#     def test_rundeck_logo(self):
#         """Make sure image_element() (rundeck_logo) is implemented."""
#         image = worker.rundeck_logo(self.dispatcher)
#
#         self.assertDictEqual(
#             image,
#             {
#                 "type": "image",
#                 "image_url": "SomeScheme://SomeHost/static/nautobot_chatops_extension_rundeck/images/Rundeck_Logo.png",
#                 "alt_text": "Rundeck Logo",
#             },
#         )
#
#     def test_default_values(self):
#         """Test Rundeck Client Default Values."""
#         self.assertTrue(self.rundeck.session.verify)
#         self.assertEqual(self.rundeck.version, "36")
#
#     @patch.object(WebClient, "chat_postEphemeral")
#     def test_rundeck_subcommand(self, mock_client):
#         """Test rundeck sub-command."""
#         mock_client.return_value = {}
#         command = worker.rundeck(
#             "help", dispatcher_class=TestSlackDispatcher.dispatcher_class, context=self.dispatcher.context
#         )
#         self.assertFalse(command)
#
#
# class TestRundeckWorker(TestCase):
#     """Test Rundeck Worker Calls."""
#
#     def setUp(self):
#         """Setup."""
#         # Load JSON Fixture
#         self.projects_json = json_fixture(f"{FIXTURES}/get_projects.json")
#         self.jobs_json = json_fixture(f"{FIXTURES}/get_project_jobs.json")
#         self.project_exec_json = json_fixture(f"{FIXTURES}/get_project_executions.json")
#         self.trigger_job_json = json_fixture(f"{FIXTURES}/trigger_job.json")
#         self.jobs_exec_json = json_fixture(f"{FIXTURES}/get_job_executions.json")
#
#         # Rundeck Client
#         self.uri = "https://rundeck-server.com"
#         self.token = "junkToken"
#         self.api_version = "40"
#         self.rundeck = Rundeck(self.uri, self.token, self.api_version)
#
#         # Dispatcher Mock
#         self.dispatcher = MagicMock()
#         self.dispatcher.prompt_from_menu = MagicMock()
#         self.dispatcher.send_error = MagicMock()
#         self.dispatcher.send_large_table = MagicMock()
#         self.dispatcher.send_markdown = MagicMock()
#         self.dispatcher.send_snippet = MagicMock()
#         self.dispatcher.send_markdown = MagicMock()
#         self.dispatcher.user_mention = MagicMock()
#         self.dispatcher.user_mention.return_value = "Ripley"
#         self.dispatcher.hyperlink = MagicMock()
#         self.dispatcher.hyperlink.return_value = (
#             "Job Results",
#             "http://ec2-52-53-205-88.us-west-1.compute.amazonaws.com/project/Prometheus/execution/show/3",
#         )
#
#     @responses.activate
#     def test_get_project_success(self):
#         """Test private `_get_project` Success."""
#
#         responses.add(
#             responses.GET,
#             f"{self.uri}/api/{self.api_version}/projects",
#             json=self.projects_json,
#             status=200,
#         )
#
#         private_get_project = worker._get_project(self.dispatcher, self.rundeck, "test-command")
#         self.dispatcher.prompt_from_menu.assert_called_once_with(
#             "rundeck test-command", "Select project name", [("Prometheus", "Prometheus")]
#         )
#         self.assertFalse(private_get_project)
#
#     @responses.activate
#     def test_get_project_bad_response(self):
#         """Test `_get_project` bad API Response."""
#
#         responses.add(
#             responses.GET,
#             f"{self.uri}/api/{self.api_version}/projects",
#             json={},
#             status=404,
#         )
#
#         private_get_project = worker._get_project(self.dispatcher, self.rundeck, "test-command")
#
#         self.dispatcher.send_error.assert_called_once_with("Rundeck API response is not 200. 404")
#         self.assertEqual(private_get_project, ("failed", "`get_projects` failed. Rundeck API Response Code: 404"))
#
#     @responses.activate
#     def test_get_job_success(self):
#         """Test `_get_job` Success."""
#
#         project = "Prometheus"
#         responses.add(
#             responses.GET,
#             f"{self.uri}/api/{self.api_version}/project/{project}/jobs",
#             json=json_fixture(f"{FIXTURES}/get_project_jobs.json"),
#             status=200,
#         )
#
#         private_get_job = worker._get_job(
#             dispatcher=self.dispatcher, rundeck_client=self.rundeck, project=project, command="test-command"
#         )
#         self.dispatcher.prompt_from_menu.assert_called_once_with(
#             "rundeck test-command", "Select job", [("Crash The Ship", "cc2d5f73-0479-4601-9986-f759ea87f18b")]
#         )
#         self.assertFalse(private_get_job)
#
#     @responses.activate
#     def test_get_job_bad_response_bad_response(self):
#         """Test `_get_job` error."""
#
#         project = "Prometheus"
#         responses.add(
#             responses.GET,
#             f"{self.uri}/api/{self.api_version}/project/{project}/jobs",
#             json=json_fixture(f"{FIXTURES}/get_project_jobs.json"),
#             status=400,
#         )
#
#         private_get_job = worker._get_job(
#             dispatcher=self.dispatcher, rundeck_client=self.rundeck, project=project, command="test-command"
#         )
#         self.dispatcher.send_error.assert_called_once_with("Rundeck API response is not 200. 400")
#         self.assertEqual(private_get_job, ("failed", "`get_job` failed. Rundeck API Response Code: 400"))
#
#     # The strategy for testing changes below this point. We instantiate a client
#     # Each time a worker call is made. So, we rely on mocking the Rundeck Client
#     @patch("nautobot_chatops_extension_rundeck.worker.Rundeck")
#     def test_get_projects_success(self, rundeck):
#         """Test `get_project` Success."""
#
#         rundeck.return_value.get_projects = MagicMock()
#         rundeck.return_value.get_projects.return_value.json.return_value = self.projects_json
#         rundeck.return_value.get_projects.return_value.ok = True
#         rundeck.return_value.get_projects.return_value.status_code = 200
#
#         get_projects = worker.get_projects(self.dispatcher)
#         self.dispatcher.send_large_table.assert_called_once_with(["Name", "Description"], [("Prometheus", "")])
#         # Updating to see if this feels more natural
#         self.dispatcher.send_markdown.assert_called_once_with(
#             "Hello, Ripley! Here is the list of projects you requested."
#         )
#         self.assertEqual(get_projects, "succeeded")
#
#     @patch("nautobot_chatops_extension_rundeck.worker.Rundeck")
#     def test_get_projects_bad_response(self, rundeck):
#         """Test `get_project` bad API Response."""
#
#         rundeck.return_value.get_projects = MagicMock()
#         rundeck.return_value.get_projects.return_value.json.return_value = {"BAD_RESPONSE": "yep"}
#         rundeck.return_value.get_projects.return_value.ok = False
#         rundeck.return_value.get_projects.return_value.status_code = 400
#
#         get_projects = worker.get_projects(self.dispatcher)
#
#         self.dispatcher.send_error.assert_called_once_with("Rundeck API response is not 200. 400")
#         self.assertEqual(get_projects, ("failed", "`get_projects` failed. Rundeck API Response Code: 400"))
#
#     # Get Jobs
#     @patch("nautobot_chatops_extension_rundeck.worker._get_project")
#     @patch("nautobot_chatops_extension_rundeck.worker.Rundeck")
#     def test_get_project_jobs_no_project(self, rundeck, get_project_mock):  # pylint: disable=unused-argument
#         """Test `get_jobs` no project passed in, prompt for project."""
#
#         get_project_mock.return_value = "Prometheus"
#
#         get_jobs = worker.get_jobs(self.dispatcher)
#         self.assertEqual(get_jobs, "Prometheus")
#
#     @patch("nautobot_chatops_extension_rundeck.worker.Rundeck")
#     def test_get_project_jobs_success(self, rundeck):
#         """Test `get_jobs` Success"""
#
#         rundeck.return_value.get_jobs = MagicMock()
#         rundeck.return_value.get_jobs.return_value.json.return_value = self.jobs_json
#         rundeck.return_value.get_jobs.return_value.ok = True
#         rundeck.return_value.get_jobs.return_value.status_code = 200
#
#         get_jobs = worker.get_jobs(self.dispatcher, "Prometheus")
#         self.dispatcher.send_markdown.assert_called_once_with("Ripley, Here is the list of jobs you requested.")
#         self.dispatcher.send_large_table.assert_called_once_with(
#             ["Name", "Enabled", "Description"], [("Crash The Ship", True, "Prometheus is down")]
#         )
#         self.assertEqual(get_jobs, "succeeded")
#
#     @patch("nautobot_chatops_extension_rundeck.worker.Rundeck")
#     def test_get_project_jobs_error(self, rundeck):
#         """Test `get_jobs` Error, bad API Response"""
#
#         rundeck.return_value.get_jobs = MagicMock()
#         rundeck.return_value.get_jobs.return_value.json.return_value = {}
#         rundeck.return_value.get_jobs.return_value.ok = False
#         rundeck.return_value.get_jobs.return_value.status_code = 400
#
#         get_jobs = worker.get_jobs(self.dispatcher, "Prometheus")
#         self.dispatcher.send_error.assert_called_once_with("Rundeck API response is not 200. 400")
#         self.assertEqual(get_jobs, ("failed", "`get_jobs` failed. Rundeck API Response Code: 400"))
#
#     @patch("nautobot_chatops_extension_rundeck.worker.Rundeck")
#     def test_get_project_exectuion_success(self, rundeck):
#         """Test `get_project_execution` Success."""
#
#         rundeck.return_value.get_project_executions = MagicMock()
#         rundeck.return_value.get_project_executions.return_value.json.return_value = self.project_exec_json
#         rundeck.return_value.get_project_executions.return_value.ok = True
#         rundeck.return_value.get_project_executions.return_value.status_code = 200
#
#         get_proj_exec = worker.get_project_executions(self.dispatcher, "Prometheus")
#         self.dispatcher.send_markdown.assert_called_once_with(
#             "Ripley, Here is the list of project executions you requested."
#         )
#         self.dispatcher.send_large_table.assert_called_once_with(
#             ["Permalink", "Status", "User", "Date Started"],
#             [
#                 (
#                     "http://ec2-52-53-205-88.us-west-1.compute.amazonaws.com/project/Prometheus/execution/show/2",
#                     "succeeded",
#                     "admin",
#                     datetime.date(2021, 10, 16),
#                 ),
#                 (
#                     "http://ec2-52-53-205-88.us-west-1.compute.amazonaws.com/project/Prometheus/execution/show/1",
#                     "succeeded",
#                     "admin",
#                     datetime.date(2021, 10, 14),
#                 ),
#             ],
#         )
#         self.assertEqual(get_proj_exec, "succeeded")
#
#     @patch("nautobot_chatops_extension_rundeck.worker._get_project")
#     @patch("nautobot_chatops_extension_rundeck.worker.Rundeck")
#     def test_get_project_executions_no_project(self, rundeck, get_project_mock):  # pylint: disable=unused-argument
#         """Test `get_project_executions` no project passed in, prompt for project."""
#
#         get_project_mock.return_value = "Prometheus"
#
#         get_project_executions = worker.get_project_executions(self.dispatcher)
#         self.assertEqual(get_project_executions, "Prometheus")
#
#     # Execute Job
#     @patch("nautobot_chatops_extension_rundeck.worker.Rundeck")
#     def test_job_execution_success(self, rundeck):
#         """Test `execute_job` Success."""
#         job_id = "cc2d5f73-0479-4601-9986-f759ea87f18b"
#
#         rundeck.return_value.trigger_job = MagicMock()
#         rundeck.return_value.trigger_job.return_value.json.return_value = self.trigger_job_json
#         rundeck.return_value.trigger_job.return_value.ok = True
#         rundeck.return_value.trigger_job.return_value.status_code = 200
#
#         execute_job = worker.execute_job(
#             self.dispatcher,
#             "Prometheus",
#             job_id,
#             False,
#             None,
#         )
#         # Send Markdown mock is called twice. Assert the list of arguments used
#         call_list = [
#             call("Stand by Ripley, I am executing the job you requested."),
#             call(
#                 "Crash The Ship has been started. View job results: ('Job Results', 'http://ec2-52-53-205-88.us-west-1.compute.amazonaws.com/project/Prometheus/execution/show/3')"
#             ),
#             call(
#                 "To rerun this command, use the following: /rundeck execute-job Prometheus cc2d5f73-0479-4601-9986-f759ea87f18b False None"
#             ),
#         ]
#         self.assertEqual(self.dispatcher.send_markdown.call_args_list, call_list)
#         self.assertEqual(self.dispatcher.send_markdown.call_count, 3)
#         self.assertEqual(execute_job, "succeeded")
#
#     # pylint:  disable=unused-argument
#     @patch("nautobot_chatops_extension_rundeck.worker.Rundeck")
#     def test_job_execution_prompt_for_need_options(self, rundeck):
#         """Test `execute_job` with `prompt_for_need_options`."""
#         job_id = "cc2d5f73-0479-4601-9986-f759ea87f18b"
#
#         execute_job = worker.execute_job(
#             self.dispatcher,
#             "Prometheus",
#             job_id,
#             None,
#         )
#         self.assertEqual(
#             self.dispatcher.prompt_from_menu.call_args,
#             call(
#                 action_id="rundeck execute-job Prometheus cc2d5f73-0479-4601-9986-f759ea87f18b",
#                 help_text="Does the Job require options?",
#                 choices=[("Yes", "yes"), ("No", "no")],
#                 default=("No", "no"),
#             ),
#         )
#         self.assertFalse(execute_job)
#
#     # pylint:  disable=unused-argument
#     @patch("nautobot_chatops_extension_rundeck.worker.Rundeck")
#     def test_job_execution_if_options(self, rundeck):
#         """Test `execute_job` with prompt for options."""
#         job_id = "cc2d5f73-0479-4601-9986-f759ea87f18b"
#
#         execute_job = worker.execute_job(
#             self.dispatcher,
#             "Prometheus",
#             job_id,
#             True,
#             None,
#         )
#         self.assertEqual(
#             self.dispatcher.prompt_for_text.call_args,
#             call(
#                 action_id="rundeck execute-job Prometheus cc2d5f73-0479-4601-9986-f759ea87f18b True",
#                 help_text="Example: option1=some_value, option2='some spaced value'",
#                 label="Please enter the job options.",
#                 title="Job Options",
#             ),
#         )
#         self.assertFalse(execute_job)
#
#     # pylint:  disable=unused-argument
#     @patch("nautobot_chatops_extension_rundeck.worker.Rundeck")
#     def test_job_execution_bad_optinos_reprompt(self, rundeck):
#         """Test `execute_job` with prompt for options."""
#         job_id = "cc2d5f73-0479-4601-9986-f759ea87f18b"
#         options = "dna perfect_match david 'created because we could'"
#
#         execute_job = worker.execute_job(
#             self.dispatcher,
#             "Prometheus",
#             job_id,
#             True,
#             options,
#         )
#         self.assertEqual(
#             self.dispatcher.prompt_for_text.call_args,
#             call(
#                 action_id="rundeck execute-job Prometheus cc2d5f73-0479-4601-9986-f759ea87f18b True",
#                 help_text="Example: option1=some_value, option2='some spaced value'",
#                 label="Please enter the job options.",
#                 title="Job Options",
#             ),
#         )
#         self.assertFalse(execute_job)
#
#     @patch("nautobot_chatops_extension_rundeck.worker._get_job")
#     @patch("nautobot_chatops_extension_rundeck.worker.Rundeck")
#     def test_job_execution_success_no_job(self, rundeck, get_job):  # pylint: disable=unused-argument
#         """Test `execute_job` without specifying job."""
#
#         get_job.return_value = "cc2d5f73-0479-4601-9986-f759ea87f18b"
#
#         execute_job = worker.execute_job(self.dispatcher, "Prometheus")
#         self.assertEqual(execute_job, "cc2d5f73-0479-4601-9986-f759ea87f18b")
#
#     @patch("nautobot_chatops_extension_rundeck.worker._get_project")
#     @patch("nautobot_chatops_extension_rundeck.worker.Rundeck")
#     def test_job_execution_success_no_project(self, rundeck, get_project):  # pylint: disable=unused-argument
#         """Test `execute_job` without specifying job."""
#
#         get_project.return_value = "Prometheus"
#
#         execute_job = worker.execute_job(self.dispatcher)
#         self.assertEqual(execute_job, "Prometheus")
#
#     @patch("nautobot_chatops_extension_rundeck.worker.Rundeck")
#     def test_job_execution_error(self, rundeck):
#         """Test `execute_job` Error."""
#         job_id = "cc2d5f73-0479-4601-9986-f759ea87f18b"
#
#         rundeck.return_value.trigger_job = MagicMock()
#         rundeck.return_value.trigger_job.return_value.json.return_value = {}
#         rundeck.return_value.trigger_job.return_value.ok = False
#         rundeck.return_value.trigger_job.return_value.status_code = 400
#
#         execute_job = worker.execute_job(self.dispatcher, "Prometheus", job_id, True, "option1=cool option")
#         self.dispatcher.send_error.assert_called_once_with("Rundeck API response is not 200. 400")
#         self.assertEqual(execute_job, ("failed", "`execute_job` failed. Rundeck API Response Code: 400"))
#
#     @patch("nautobot_chatops_extension_rundeck.worker.Rundeck")
#     def test_job_execution_success_argstring_options(self, rundeck):
#         """Test `execute_job` Success with argstring."""
#         job_id = "cc2d5f73-0479-4601-9986-f759ea87f18b"
#
#         rundeck.return_value.trigger_job = MagicMock()
#         rundeck.return_value.trigger_job.return_value.json.return_value = self.trigger_job_json
#         rundeck.return_value.trigger_job.return_value.ok = True
#         rundeck.return_value.trigger_job.return_value.status_code = 200
#         argstring = "option_one=some_value, option_two=some second value"
#
#         execute_job = worker.execute_job(self.dispatcher, "Prometheus", job_id, True, argstring)
#         # Send Markdown mock is called twice. Assert the list of arguments used
#         call_list = [
#             call(
#                 "Stand by Ripley, I am executing the job you requested with the following 2 options: {'option_one': 'some_value', 'option_two': 'some second value'}"
#             ),
#             call(
#                 "Crash The Ship has been started. View job results: ('Job Results', 'http://ec2-52-53-205-88.us-west-1.compute.amazonaws.com/project/Prometheus/execution/show/3')"
#             ),
#             call(
#                 "To rerun this command, use the following: /rundeck execute-job Prometheus cc2d5f73-0479-4601-9986-f759ea87f18b True 'option_one=some_value, option_two=some second value'"
#             ),
#         ]
#
#         self.assertEqual(self.dispatcher.send_markdown.call_args_list, call_list)
#         self.assertEqual(self.dispatcher.send_markdown.call_count, 3)
#         self.assertEqual(execute_job, "succeeded")
#
#     # Get Job Definition
#     @patch("nautobot_chatops_extension_rundeck.worker._get_job")
#     @patch("nautobot_chatops_extension_rundeck.worker.Rundeck")
#     def test_job_definition_success_no_job(self, rundeck, get_job):  # pylint: disable=unused-argument
#         """Test `get_job_definition` without specifying job."""
#
#         get_job.return_value = "cc2d5f73-0479-4601-9986-f759ea87f18b"
#
#         get_job_definition = worker.get_job_definition(self.dispatcher, "Prometheus")
#         self.assertEqual(get_job_definition, "cc2d5f73-0479-4601-9986-f759ea87f18b")
#
#     @patch("nautobot_chatops_extension_rundeck.worker._get_project")
#     @patch("nautobot_chatops_extension_rundeck.worker.Rundeck")
#     def test_get_job_definition_success_no_project(self, rundeck, get_project):  # pylint: disable=unused-argument
#         """Test `get_job_definition` without specifying job."""
#
#         get_project.return_value = "Prometheus"
#
#         get_job_definition = worker.get_job_definition(self.dispatcher)
#         self.assertEqual(get_job_definition, "Prometheus")
#
#     @patch("nautobot_chatops_extension_rundeck.worker.Rundeck")
#     def test_get_job_definition_error(self, rundeck):
#         """Test `get_job_definition` Error."""
#         job_id = "cc2d5f73-0479-4601-9986-f759ea87f18b"
#
#         rundeck.return_value.get_job_definition = MagicMock()
#         rundeck.return_value.get_job_definition.return_value.ok = False
#         rundeck.return_value.get_job_definition.return_value.status_code = 400
#
#         get_job_definition = worker.get_job_definition(self.dispatcher, "Prometheus", job_id)
#         self.dispatcher.send_error.assert_called_once_with("Rundeck API response is not 200. 400")
#         self.assertEqual(get_job_definition, ("failed", "`get_job_definition` failed. Rundeck API Response Code: 400"))
#
#     @patch("nautobot_chatops_extension_rundeck.worker.Rundeck")
#     def test_get_job_definition_success(self, rundeck):
#         """Test `get_job_definition` Success."""
#         job_id = "cc2d5f73-0479-4601-9986-f759ea87f18b"
#
#         rundeck.return_value.get_job_definition = MagicMock()
#         rundeck.return_value.get_job_definition.return_value.text = "Job Definition Text"
#         rundeck.return_value.get_job_definition.return_value.ok = True
#         rundeck.return_value.get_job_definition.return_value.status_code = 200
#
#         get_job_definition = worker.get_job_definition(self.dispatcher, "Prometheus", job_id)
#         self.dispatcher.send_markdown.assert_called_once_with("Ripley, Here is the job definition you requested.")
#         self.dispatcher.send_snippet.assert_called_once_with("Job Definition Text")
#         self.assertEqual(get_job_definition, "succeeded")
#
#     # Get Job Executions
#     @patch("nautobot_chatops_extension_rundeck.worker._get_job")
#     @patch("nautobot_chatops_extension_rundeck.worker.Rundeck")
#     def test_get_job_exec_success_no_job(self, rundeck, get_job):  # pylint: disable=unused-argument
#         """Test `get_job_executions` without specifying job."""
#
#         get_job.return_value = "cc2d5f73-0479-4601-9986-f759ea87f18b"
#
#         get_job_executions = worker.get_job_executions(self.dispatcher, "Prometheus")
#         self.assertEqual(get_job_executions, "cc2d5f73-0479-4601-9986-f759ea87f18b")
#
#     @patch("nautobot_chatops_extension_rundeck.worker._get_project")
#     @patch("nautobot_chatops_extension_rundeck.worker.Rundeck")
#     def test_get_job_exec_success_no_project(self, rundeck, get_project):  # pylint: disable=unused-argument
#         """Test `get_job_executions` without specifying job."""
#
#         get_project.return_value = "Prometheus"
#
#         get_job_executions = worker.get_job_executions(self.dispatcher)
#         self.assertEqual(get_job_executions, "Prometheus")
#
#     @patch("nautobot_chatops_extension_rundeck.worker.Rundeck")
#     def test_get_job_exec_success_no_status(self, rundeck):  # pylint: disable=unused-argument
#         """Test `get_job_executions` without status, prompt from menu."""
#
#         job_id = "cc2d5f73-0479-4601-9986-f759ea87f18b"
#         project = "Prometheus"
#
#         get_job_executions = worker.get_job_executions(self.dispatcher, project, job_id)
#         self.dispatcher.prompt_from_menu.assert_called_once_with(
#             "rundeck get-job-executions Prometheus cc2d5f73-0479-4601-9986-f759ea87f18b",
#             "Select status",
#             [
#                 ("All", "all"),
#                 ("Succeeded", "succeeded"),
#                 ("Failed", "failed"),
#                 ("Aborted", "aborted"),
#                 ("Running", "running"),
#             ],
#         )
#         self.assertFalse(get_job_executions)
#
#     @patch("nautobot_chatops_extension_rundeck.worker.Rundeck")
#     def test_get_job_exec_success_all_params_success_all(self, rundeck):  # pylint: disable=unused-argument
#         """Test `get_job_executions` with all params success."""
#
#         job_id = "cc2d5f73-0479-4601-9986-f759ea87f18b"
#         project = "Prometheus"
#
#         rundeck.return_value.get_job_executions = MagicMock()
#         rundeck.return_value.get_job_executions.return_value.json.return_value = self.jobs_exec_json
#         rundeck.return_value.get_job_executions.return_value.ok = True
#         rundeck.return_value.get_job_executions.return_value.status_code = 200
#
#         get_job_executions = worker.get_job_executions(self.dispatcher, project, job_id, "all")
#         self.assertTrue(get_job_executions, "Prometheus")
#         self.dispatcher.send_markdown.assert_called_once_with(
#             "Ripley, Here is the list of job executions you requested."
#         )
#         self.dispatcher.send_large_table.assert_called_once_with(
#             ["Permalink", "Status", "User", "Date Started"],
#             [
#                 (
#                     "http://ec2-52-53-205-88.us-west-1.compute.amazonaws.com/project/Prometheus/execution/show/2",
#                     "succeeded",
#                     "admin",
#                     datetime.date(2021, 10, 16),
#                 ),
#                 (
#                     "http://ec2-52-53-205-88.us-west-1.compute.amazonaws.com/project/Prometheus/execution/show/1",
#                     "succeeded",
#                     "admin",
#                     datetime.date(2021, 10, 14),
#                 ),
#             ],
#         )
#
#     @patch("nautobot_chatops_extension_rundeck.worker.Rundeck")
#     def test_get_job_exec_success_all_params_success(self, rundeck):  # pylint: disable=unused-argument
#         """Test `get_job_executions` without all as status."""
#
#         job_id = "cc2d5f73-0479-4601-9986-f759ea87f18b"
#         project = "Prometheus"
#
#         rundeck.return_value.get_job_executions = MagicMock()
#         rundeck.return_value.get_job_executions.return_value.json.return_value = self.jobs_exec_json
#         rundeck.return_value.get_job_executions.return_value.ok = True
#         rundeck.return_value.get_job_executions.return_value.status_code = 200
#
#         get_job_executions = worker.get_job_executions(self.dispatcher, project, job_id, "succeeded")
#         self.assertTrue(get_job_executions, "Prometheus")
#         self.dispatcher.send_large_table.assert_called_once_with(
#             ["Permalink", "Status", "User", "Date Started"],
#             [
#                 (
#                     "http://ec2-52-53-205-88.us-west-1.compute.amazonaws.com/project/Prometheus/execution/show/2",
#                     "succeeded",
#                     "admin",
#                     datetime.date(2021, 10, 16),
#                 ),
#                 (
#                     "http://ec2-52-53-205-88.us-west-1.compute.amazonaws.com/project/Prometheus/execution/show/1",
#                     "succeeded",
#                     "admin",
#                     datetime.date(2021, 10, 14),
#                 ),
#             ],
#         )
