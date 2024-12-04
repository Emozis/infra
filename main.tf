module "emogi_app" {
  source        = "./modules/ec2"
  instance_name = "emogi-ec2-app"
  ami_id        = "ami-0f1e61a80c7ab943e"
  instance_type = "t3.micro"
  user_data_path = "script/initail_server_setting.sh"
}