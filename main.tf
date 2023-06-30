 
resource "aws_instance" "rhel" {
  ami           = "ami-02b8534ff4b424939"
  instance_type = "t2.micro"
  key_name = "new-key1"
  subnet_id = resource.aws_subnet.my_subnet_1.id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.my_security_group.id]

tags = {
        Name= "my_ec2"
  }

    connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("./new-key1.pem")
    host     = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
       "sudo dnf install -y ansible-core",
        "sudo yum -y install git",
        "ansible core --version",
        "git --version",
        "curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py",
        "python3 get-pip.py --user", 
        "python3 -m pip install --user ansible",
        "sudo mkdir -p /mount-test",
       
    ]
  }
}

  resource "aws_ebs_volume" "example" {
  availability_zone = aws_instance.rhel.availability_zone
  size              = 10

  tags = {
    Name = "New_vol"
  }
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/xvdf"
  volume_id   = aws_ebs_volume.example.id
  instance_id = aws_instance.rhel.id
}

#  resource "null_resource" "configure_vdo" {
#  depends_on = [ aws_volume_attachment.ebs_att ]
 
 
#  connection {
#    type = "ssh"
#    user = "ec2-user"
#    private_key = file("./new-key1.pem")
#    host = aws_instance.rhel.public_ip
#  }

#  provisioner "remote-exec" {
#    inline = [
#          "sudo su -"
#         "sudo dnf update -y",
#         "sudo yum install lvm2 kmod-kvdo vdo -y",
#          " sudo reboot"
#         "sudo vgcreate homevg /dev/xvdf",
#         "sudo lvcreate --type vdo --name homelv --size 8G --virtualsize 15G  homevg",
#         "sudo mkfs.xfs -K /dev/homevg/homelv",
#         "sudo mount /dev/mapper/homevg-homelv /mount-test/",
#         "sudo echo  '/dev/mapper/homevg-homelv                       /mount-test                   xfs     defaults        0 0 ' >> /etc/fstab"
       
#     ]
#   }
#   }



output "public_ip" {
  value = aws_instance.rhel.public_ip
}
