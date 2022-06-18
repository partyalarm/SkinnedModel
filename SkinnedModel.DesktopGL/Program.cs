using System;

namespace SkinnedModel
{
    public static class Program
    {
        [STAThread]
        static void Main()
        {
            using (var engine = new Engine())
                engine.Run();
        }
    }
}
