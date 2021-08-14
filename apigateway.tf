resource "aws_api_gateway_rest_api" "myrestapi" {
  name        = "MyRestAPI"
  description = "This is my Rest API for demonstration purposes"
}

resource "aws_api_gateway_resource" "myrestapi" {
  rest_api_id = aws_api_gateway_rest_api.myrestapi.id
  parent_id   = aws_api_gateway_rest_api.myrestapi.root_resource_id
  path_part   = "demo"
}

resource "aws_api_gateway_method" "myrestapi" {
  rest_api_id   = aws_api_gateway_rest_api.myrestapi.id
  resource_id   = aws_api_gateway_resource.myrestapi.id
  http_method   = "GET"
  authorization = "NONE"
  request_parameters = {"method.request.querystring.message" = false}
}

resource "aws_api_gateway_integration" "myrestapi" {
  rest_api_id = aws_api_gateway_rest_api.myrestapi.id
  resource_id = aws_api_gateway_resource.myrestapi.id
  http_method = aws_api_gateway_method.myrestapi.http_method
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = aws_lambda_function.myapi_function.invoke_arn
  credentials = aws_iam_role.api_gateway_role.arn
}

resource "aws_api_gateway_method_response" "myrestapi" {
  rest_api_id = aws_api_gateway_rest_api.myrestapi.id
  resource_id = aws_api_gateway_resource.myrestapi.id
  http_method = aws_api_gateway_method.myrestapi.http_method
  status_code = "200"
}

resource "aws_api_gateway_deployment" "myrestapi" {
  rest_api_id = aws_api_gateway_rest_api.myrestapi.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.myrestapi.id,
      aws_api_gateway_method.myrestapi.id,
      aws_api_gateway_integration.myrestapi.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "myrestapi" {
  deployment_id = aws_api_gateway_deployment.myrestapi.id
  rest_api_id   = aws_api_gateway_rest_api.myrestapi.id
  stage_name    = "live"
}