provider "aws" { 
   region = var.region
   default_tags  {
       tags=var.tags
   }
      
}

terraform {  
    required_providers {    
        aws = {      
            
            version = ">=3.38.0"
        }
    }
}