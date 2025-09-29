from azure.storage.blob import BlobServiceClient

conn_str = "UseDevelopmentStorage=true"
service = BlobServiceClient.from_connection_string(conn_str)

container_name = "demo"
blob_name = "hello.txt"

service.create_container(container_name)
blob = service.get_blob_client(container=container_name, blob=blob_name)
blob.upload_blob(b"hola azurite", overwrite=True)
print(blob.download_blob().readall().decode("utf-8"))
