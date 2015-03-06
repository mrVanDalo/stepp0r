

function TrackPaginator:__init_lib()
    self._page_offset         = 0
    self.__page_offset_factor = 1
end
function TrackPaginator:__activate_lib()
end
function TrackPaginator:__deactivate_lib()
end

function TrackPaginator:_page_inc()
    self._page_offset = self._page_offset  +  self.__page_offset_factor
end

function TrackPaginator:_page_dec()
    self._page_offset = self._page_offset  -  self.__page_offset_factor
    if( self._page_offset < 0 ) then
        self._page_offset = 0
    end
end
