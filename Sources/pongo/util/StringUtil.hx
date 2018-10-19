package pongo.util;

class StringUtil
{
    public static function keyFromStrings(strs :Array<String>) : Int
    {
        strs.sort(function(a,b) {
            a = a.toLowerCase();
            b = b.toLowerCase();
            if (a < b) return -1;
            if (a > b) return 1;
            return 0;
        });

        var hash :Int = 7;
        for(str in strs) {
            var i = 0;
            while(i < str.length) {
                hash = hash*31 + str.charCodeAt(i);
                i++;
            }
        }

        return hash;
    }
}