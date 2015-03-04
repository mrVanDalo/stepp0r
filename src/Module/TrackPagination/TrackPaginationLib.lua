

function TrackPagination:__init_lib()
    self.__page_offset = 0
    self.__page_offset_factor = 1
end
function TrackPagination:__activate_lib()
end
function TrackPagination:__deactivate_lib()
end

function Chooser:_page_inc()
    self._page_offset = self._page_offset  +  self.__page_offset_factor
end

function Chooser:_page_dec()
    self._page_offset = self._page_offset  -  self.__page_offset_factor
    if( self._page_offset < 0 ) then
        self._page_offset = 0
    end
end
