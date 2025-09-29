using Azure.Storage.Blobs;
using System;
using System.Threading.Tasks;

class Program
{
    static async Task Main()
    {
        var connStr = "UseDevelopmentStorage=true";
        var service = new BlobServiceClient(connStr);

        string containerName = "demo";
        string blobName = "hello.txt";

        var container = service.GetBlobContainerClient(containerName);
        await container.CreateIfNotExistsAsync();

        var blob = container.GetBlobClient(blobName);
        await blob.UploadAsync(BinaryData.FromString("hola azurite"), overwrite: true);
        var content = await blob.DownloadContentAsync();
        Console.WriteLine(content.Value.Content.ToString());
    }
}
