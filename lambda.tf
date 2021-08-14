data "template_file" "lambda_function_tpl" {
  template = file("./myfunction.tpl")
}

data "archive_file" "lambda_function_payload" {
  type        = "zip"
  output_path = "myfunction.zip"
  
  source {
    content  = data.template_file.lambda_function_tpl.rendered
    filename = "lambda_function.py"
  }
}

resource "aws_lambda_function" "myapi_function" {
  filename      = data.archive_file.lambda_function_payload.output_path
  function_name = "myapi-lambda-function"
  role          = aws_iam_role.lambda_function_role.arn
  handler       = "lambda_function.lambda_handler"

  source_code_hash = data.archive_file.lambda_function_payload.output_base64sha256

  runtime = "python3.8"
}
