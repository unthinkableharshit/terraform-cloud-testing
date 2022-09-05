resource "azurerm_linux_virtual_machine" "myubuntu" {
  # count=2
  # name                  = "myubuntu20.04-${count.index}"
  name                  = var.vm_name
  resource_group_name   = azurerm_resource_group.newrg.name
  location              = azurerm_resource_group.newrg.location
  size                  = "Standard_DS1_v2"
  admin_username        = "harshit"
  network_interface_ids = [azurerm_network_interface.mynic.id]

  admin_ssh_key {
    username   = "harshit"
    public_key = file("${path.module}/ssh-vm.pub.pub")
  }
  # admin_password = "KV5WCQJhw47GZVn"
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  connection {
    type        = "ssh"
    user        = self.admin_username
    private_key = file("${path.module}/ssh-vm.pub")
    host        = self.public_ip_address
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt install nginx -y",
      "cd /var/www/html",
      "sudo rm index.html",
      "sudo touch index.html",
      "echo 'I can  without double quotes' >> index.html",
    ]
    on_failure = continue
  }
  tags = {
    environment = "staging"
    Name = "created by Harshit Jain"
  } #  source_image_reference {
  #   publisher = "MicrosoftWindowsServer"
  #   offer     = "WindowsServer"
  #   sku       = "2019-Datacenter"
  #   version   = "latest"
  # }
  # custom_data = filebase64("${path.module}/cloud-init.txt") //used to convert data in base 64 which is useful for custom data
}

