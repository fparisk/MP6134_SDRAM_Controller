class sdrcSB;
    int store[$]; // Deprecated for second project.
    int dir[$];
    int burstLenght[$];
    int ErrCnt;

    task clearStore();
        begin
            // clear the data in the scoreboard
            //store = {}{};
            dir = {};
            burstLenght={};
            ErrCnt = 0;
        end
    endtask //automatic
endclass