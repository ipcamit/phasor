function [] = archive_usr_data()
    zipFileName=input('Input archive name:>','s')
    current_time=clock;
    savename=strcat('../Archive_',zipFileName,'_',num2str(current_time(3)),'_',num2str(current_time(2)),'_',num2str(current_time(1)),'_',num2str(current_time(4)),'_',num2str(current_time(5)),'_',num2str(round(current_time(6))),'_','.zip');
    zip(savename,'../usr_data')
    copyfile(savename,'../usr_data')
    delete(savename)
end