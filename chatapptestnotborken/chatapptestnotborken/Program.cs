using chatapptestnotborken.Client.Pages;
using chatapptestnotborken.Components;
using chatapptestnotborken.Hubs;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddRazorComponents()
    .AddInteractiveWebAssemblyComponents();
 
builder.Services.AddSignalR();

builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(builder =>
    {
        builder.AllowAnyMethod()
            .AllowAnyHeader()
            .AllowAnyOrigin();
    });
});

builder.Logging.AddConsole();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseWebAssemblyDebugging();
}
else
{
    app.UseExceptionHandler("/Error", createScopeForErrors: true);
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles(); // Add this if not already present
app.UseRouting();  
app.UseCors();
app.UseAntiforgery();


app.MapBlazorHub();
app.MapStaticAssets();
app.MapRazorComponents<App>()
    .AddInteractiveWebAssemblyRenderMode()
    .AddAdditionalAssemblies(typeof(chatapptestnotborken.Client._Imports).Assembly);

app.MapHub<ChatHub>("/chatHub"); 

app.Run();